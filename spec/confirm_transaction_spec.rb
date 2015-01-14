require 'spec_helper'
require 'debugger'

describe Lipisha::ConfirmTransaction do
  subject { Lipisha::ConfirmTransaction.new({
    transaction: 'ABCI23564'
    })
  }

  it { expect(subject.transaction).to eql('ABCI23564') }

  it { should respond_to(:transaction) }
  it { should respond_to(:response) }
  it { should respond_to(:status_code) }
  it { should respond_to(:status_description) }
  it { should respond_to(:transaction_status) }
  it { should respond_to(:transaction_reference) }
  it { should respond_to(:transaction_sender_name) }
  it { should respond_to(:transaction_mobile_number) }
  it { should respond_to(:transaction_amount) }

  describe 'request params' do
    before do
      Lipisha.configure do |c|
        c.api_key = 'api-key'
        c.api_signature = 'api-signiture'
      end
    end

    subject do Lipisha::ConfirmTransaction.new({
      transaction: 'ABCI23564'
      })
    end

    it do
      expect(subject.to_params).to eql({
        api_key: 'api-key',
        api_signature: 'api-signiture',
        api_version: '1.3.0',
        api_type: 'Callback',
        transaction: 'ABCI23564'
      })
    end
  end

  describe 'confirming transaction' do

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

      subject { Lipisha::ConfirmTransaction.new(:transaction => 'ABCI23564') }
      before { expect(subject.connection).to receive(:post).with(Lipisha::ConfirmTransaction::CALL_URL, subject.to_params).and_return(response) }

      it 'parses the response and sets accessors' do
        expect(subject.confirm!).to eql(false)
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
          "content": [{
    	      "transaction": "ABCI23564",
            "transaction_type": "Payment",
            "transaction_method": "Paybill (M-Pesa)",
            "transaction_date": "2013-07-18 12:23:57",
            "transaction_account_name": "Test Account",
            "transaction_account_number": "00155",
            "transaction_reference": "LS0009",
            "transaction_amount": "15.0000",
            "transaction_status": "Completed",
            "transaction_name": "JOHN JANE DOE",
            "transaction_mobile_number": "254722002222",
            "transaction_email": ""
          }]
        }})
      end
      subject { Lipisha::ConfirmTransaction.new(:transaction => 'ABCI23564') }
      before { expect(subject.connection).to receive(:post).with(Lipisha::ConfirmTransaction::CALL_URL, subject.to_params).and_return(response) }

      it 'parses the response and sets accessors' do
        expect(subject.confirm!).to eql(true)
        expect(subject.status_code).to eql('0000')
        expect(subject.status_description).to eql('description')
        expect(subject.transaction_reference).to eql('ABCI23564')
        expect(subject.transaction_amount).to eql('15.0000')
        expect(subject.transaction_status).to eql('Completed')
        expect(subject.transaction_sender_name).to eql('JOHN JANE DOE')
        expect(subject.transaction_mobile_number).to eql('254722002222')
      end
    end
  end
end
