require 'net/http'
require 'uri'
require 'json'

class IPStackService
  API_BASE_URL = 'http://api.ipstack.com/'

  def initialize(ip_address)
    @ip_address = ip_address
  end

  def retrieve_data
    uri = URI("#{API_BASE_URL}#{@ip_address}?access_key=#{ENV['IPSTACK_API_KEY']}")
    response = Net::HTTP.get_response(uri)

    return JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)

    raise "Error: Unable to retrieve data from IPStack API. Response code: #{response.code}"
  end

  def serialize(data)
    {
      country_name: data['country_name'],
      city: data['city'],
      latitude: data['latitude'],
      longitude: data['longitude']
    }
  end
end
