# CraftyClicks

This gem allows you to use the Crafty Clicks Address lookup API in your Rails apps (and also in plain Ruby).

## Installation

Add this line to your application's Gemfile:

    gem 'crafty_clicks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crafty_clicks

## Usage

### Basic Example

```ruby
[1] pry(main)> cc = CraftyClicks.new(key: 'your-api-key', env: :production)
# => #<CraftyClicks:0x000001061ea648 @env=:production, @key="your-api-key">

[2] pry(main)> cc.lookup_postcode('aa11aa')
# => {:addresses=>
#   ["LITTLE COTTAGE 17 HIGH STREET",
#    "BIG HOUSE HIGH STREET",
#    "1 HIGH STREET",
#    "3 HIGH STREET",
#    "7 HIGH STREET"],
#  :town=>"BIG CITY",
#  :postcode=>"AA1 1AA"}
```

### Advanced Example

```ruby
class Address
  def self.lookup_provider
    @@provider ||= CraftyClicks.new(
      key: Rails.application.secrets.crafty_clicks_key,
      env: Rails.env.to_sym
    )
  end

  def self.find_by(postcode:)
    raise 'Must provide a postcode' if postcode.blank?
    lookup_provider.lookup_postcode postcode
  end
end

[1] pry(main)> Address.find_by(postcode: 'aa11ab')
# => {:addresses=>
#   ["LITTLE HOUSE CRAFTYIER ROAD",
#    "CUTE HOUSE CRAFTYIER ROAD",
#    "SMALL COTTAGE CRAFTYIER ROAD",
#    "1C, CRAFTY HOUSE A BUSINESS CENTRE, CRAFTY ROAD",
#    "1B, CRAFTY HOUSE A BUSINESS CENTRE, CRAFTY ROAD",
#    "1A, CRAFTY HOUSE A BUSINESS CENTRE, CRAFTY ROAD"],
#  :town=>"BIG CITY",
#  :postcode=>"AA1 1AB"}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/crafty_clicks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
