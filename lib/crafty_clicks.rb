require 'json'
require 'uri'
require 'net/http'

class CraftyClicks
  RAPID_URL = 'http://pcls1.craftyclicks.co.uk/json/rapidaddress'

  def initialize(key:, env: :test)
    # Only set the auth key if in production (to avoid unwanted charges)
    @env = env
    @key = @env == :production ? key : nil
  end

  def lookup_postcode(postcode)
    addresses(lookup_postcode_cached(postcode))
  end

private
  
  def addresses(json)
    # Format the list of delivery points into a readable list
    address_list = json['delivery_points'].map do |delivery_point|
      address = ""
      address += delivery_point['line_1'] unless delivery_point['line_1']. == ""
      address += " #{delivery_point['line_2']}" unless delivery_point['line_2']. == ""

      address
    end.sort do |a1, a2|
      # Sort by house number where possible
      a1.match(/^[0-9]+/).try(:[], 0).to_i <=>
      a2.match(/^[0-9]+/).try(:[], 0).to_i
    end

    {
      addresses: address_list,
      town: json['town'],
      postcode: json['postcode']
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
