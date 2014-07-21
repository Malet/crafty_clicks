require 'json'
require 'uri'
require 'net/http'

class CraftyClicks
  RAPID_URL = 'http://pcls1.craftyclicks.co.uk/json/rapidaddress'
  # BASIC_URL = 'http://pcls1.craftyclicks.co.uk/json/basicaddress'
  def initialize(key:, env: :test, type: :rapid)
    # Only set the auth key if in production (to avoid unwanted charges)
    @env, @type = env, type
    @key = @env == :production ? key : nil
  end

  def lookup_postcode(postcode)
    addresses(lookup_postcode_cached(postcode))
  end

private
  
  def addresses(json)
    {
      addresses: json['delivery_points'].map do |delivery_point|
        {
          line_1: delivery_point['line_1'],
          line_2: delivery_point['line_2']
          # line3: thoroughfare['thoroughfare_name'],
          # line4: thoroughfare['thoroughfare_descriptor']
        }
      end,
      town: json['town'],
      postcode: json['postcode']
      # postal_county: json['postal_county'],
      # traditional_county: json['traditional_county'],
      # dependent_locality: json['dependent_locality'],
      # double_dependent_locality: json['double_dependent_locality'],
    }
  end

  def lookup_postcode_uncached(postcode)
    form_hash = { postcode: postcode, response: 'data_formatted'}
    form_hash.merge!({ key: @key }) if @key
    uri = URI(RAPID_URL)
    uri.query = URI.encode_www_form(form_hash)
    
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end

  def lookup_postcode_cached(postcode)
    # Automatically use the rails cache if it's available
    if defined? Rails
      key = ['craftyclicks', @env, postcode]
      if cached = Rails.cache.fetch(key)
        return cached
      else
        json = lookup_postcode_uncached(postcode)
        Rails.cache.write key, json
        return json
      end
    else
      return lookup_postcode_uncached(postcode)
    end
  end
end
