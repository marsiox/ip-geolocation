require 'json'
require_relative './base_controller'
require_relative '../../lib/ipstack_service'

class GeolocationsController < BaseController
  def call(env)
    req = Rack::Request.new(env)
    resolve(req)
  end

  def resolve(req)
    return authorize_request(req) unless authorize_request(req) == true

    body = JSON.parse(req.body.read)

    return render_400 unless valid_request?(req, body)

    redis_key = body['ip']
    record = fetch_from_redis(redis_key)

    if record.any?
      result = { geolocation: record }
    else
      result = retrieve_and_store_geolocation(redis_key)
    end

    render_json(result)
  end

  private

  def fetch_from_redis(key)
    @redis.hgetall(key)
  end

  def retrieve_and_store_geolocation(key)
    service = IPStackService.new(key)
    data = service.retrieve_data
    serialized_data = service.serialize(data)

    @redis.hmset(key, *serialized_data.flatten)
    { geolocation: serialized_data }
  end

  def valid_request?(req, body)
    req.media_type == 'application/json' && valid_ip?(body['ip'])
  end

  def valid_ip?(ip)
    IPAddr.new(ip)
    true
  rescue IPAddr::InvalidAddressError, IPAddr::AddressFamilyError
    false
  end
end
