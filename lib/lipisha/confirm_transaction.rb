module Lipisha
  class ConfirmTransaction
    CALL_URL = 'https://lipisha.com/payments/accounts/index.php/v2/api/confirm_transaction'

    attr_accessor :transaction
    attr_accessor :success, :response_body, :response, :status_code, :status_description, :transaction_reference
    attr_accessor :transaction_amount, :transaction_status, :transaction_sender_name, :transaction_mobile_number

    def initialize(args)
      @transaction = args[:transaction]
    end

    def confirm!
      self.response_body = connection.post(CALL_URL, self.to_params).body
      self.response      = JSON.parse(self.response_body)
      status                  = response['status'] || {}
      self.status_code        = status['status_code']
      self.status_description = status['status_description']
      self.success            = status['status'] == 'SUCCESS'
      if response['content'] && !response['content'].empty?
        #this assumes that we'll be only checking one confirmation code at a time
        content = response['content'].first
      else
        content = {}
      end
      self.transaction_reference      = content['transaction']
      self.transaction_amount         = content['transaction_amount']
      self.transaction_status         = content['transaction_status']
      self.transaction_sender_name    = content['transaction_name']
      self.transaction_mobile_number  = content['transaction_mobile_number']
      return self.success
    rescue => e
      self.success = false
    end

    def to_params
      {
        api_key: Lipisha.config.api_key,
        api_signature: Lipisha.config.api_signature,
        api_version: Lipisha.config.api_version,
        api_type: Lipisha.config.api_type,
        transaction: self.transaction
      }
    end

    def connection
      @connection ||= Faraday.new do |faraday|
        faraday.request :url_encoded
        faraday.adapter  Faraday.default_adapter
        faraday.use(Faraday::Response::Logger, Lipisha.logger) if Lipisha.logger
      end
    end
  end
end
