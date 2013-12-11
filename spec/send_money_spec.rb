require 'spec_helper'

describe Lipisha::SendMoney do
  subject { Lipisha::SendMoney.new({
    account_number: 'AN',
    mobile_number:  '+254123456',
    amount: '1000'
    })
  }

  it { expect(subject.account_number).to eql('AN') }
  it { expect(subject.mobile_number).to eql('+254123456') }
  it { expect(subject.amount).to eql('1000') }

  it { should respond_to(:account_number) }
  it { should respond_to(:mobile_number) }
  it { should respond_to(:amount) }
  it { should respond_to(:response) }
  it { should respond_to(:status_code) }
  it { should respond_to(:status_description) }
  it { should respond_to(:customer_name) }
  it { should respond_to(:sent_amount) }

  describe 'request params' do
    before do
      Lipisha.configure do |c|
        c.api_key = 'api-key'
        c.api_signature = 'api-signiture'
      end
    end

    subject do Lipisha::SendMoney.new({
      account_number: 'AN',
      mobile_number:  '+254123456',
      amount: '1000'
      })
    end

    it do
      expect(subject.to_params).to eql({
        api_key: 'api-key',
        api_signature: 'api-signiture',
        api_version: '1.3.0',
        api_type: 'Callback',
        account_number: 'AN',
        mobile_number: '+254123456',
        amount: '1000'
      })
    end
  end

  describe 'sending money' do

    describe "invalid request" do
      let(:response) do
        double(:body => %Q{{
            "status": {
            "status_code": "0200",
            "status_description": "description",
            "status": "FAIL"
          },
          "content": []
        }})
      end

      subject { Lipisha::SendMoney.new(:amount => 1234, :mobile_number => '+25412345', :account_number => 'a') }
      before { subject.connection.should_receive(:post).with(Lipisha::SendMoney::CALL_URL, subject.to_params).and_return(response) }

      it 'parses the response and sets accessors' do
        expect(subject.send!).to eql(false)
        expect(subject.status_code).to eql('0200')
        expect(subject.status_description).to eql('description')
      end
    end
    describe "success" do
      let(:response) do
        double(:body => %Q{{
            "status": {
            "status_code": "0000",
            "status_description": "description",
            "status": "SUCCESS"
          },
          "content": {
            "mobile_number": "+25412345",
            "amount": "1234",
            "reference": "ref",
            "customer_name": "name"
          }
        }})
      end
      subject { Lipisha::SendMoney.new(:amount => 1234, :mobile_number => '+25412345', :account_number => 'a') }
      before { subject.connection.should_receive(:post).with(Lipisha::SendMoney::CALL_URL, subject.to_params).and_return(response) }

      it 'parses the response and sets accessors' do
        expect(subject.send!).to eql(true)
        expect(subject.status_code).to eql('0000')
        expect(subject.status_description).to eql('description')
        expect(subject.reference).to eql('ref')
        expect(subject.customer_name).to eql('name')
        expect(subject.sent_amount).to eql('1234')
      end

    end
  end
end
