# Lipisha

A gem to interact with the Lipisha API. 

Currently supporting the SendMoney endpoint. 

## Usage

set your API credentials:

```ruby
Lipisha.configure do |config|
  config.api_key = '...'
  config.api_signature = '...'
end
```

Send money:

```ruby

send_money = Lipisha::SendMoney.new(:amount => 1234, :account_number => '...', :mobile_number => '...')
if send_money.send!
  puts send_money.customer_name
  puts send_money.reference
  puts send_money.sent_amount
  puts send_money.success
  puts send_money.status_code
  puts send_money.status_description
else
  puts send_money.response_body
end

```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
