module Lipisha
  class SendMoney
    CALL_URL = 'https://www.lipisha.com/payments/accounts/index.php/v2/api/send_money'

    attr_accessor :account_number, :mobile_number, :amount
    attr_accessor :success, :response, :status_code, :status_description, :reference, :customer_name, :sent_amount

    def initialize(args)
      @account_number = args[:account_number]
      @mobile_number  = args[:mobile_number]
      @amount         = args[:amount]
    end

    def amount=(val)
      @amount = val
    end

    def send!
      self.response = JSON.parse connection.post(CALL_URL, self.to_params).body
      status                  = response['status'] || {}
      self.status_code        = status['status_code']
      self.status_description = status['status_description']
      self.success            = status['status'] == 'SUCCESS'
      content                 = response['content'] || {}
      self.reference          = content['reference']
      self.customer_name      = content['customer_name']
      self.sent_amount        = content['amount']
      return self.success
    rescue => e
      self.success            = false
    end

    def to_params
      {
        api_key: Lipisha.config.api_key,
        api_signature: Lipisha.config.api_signature,
        api_version: Lipisha.config.api_version,
        api_type: Lipisha.config.api_type,
        account_number: self.account_number,
        mobile_number: self.mobile_number,
        amount: self.amount
      }
    end

    def connection
      @connection ||= Faraday.new do |faraday|
        faraday.adapter  Faraday.default_adapter
        faraday.use(Faraday::Response::Logger, Lipisha.logger) if Lipisha.logger
      end
    end
  end
end
