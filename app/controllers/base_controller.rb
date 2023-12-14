require 'redis'

class BaseController
  ROUTES = {
    '/geolocation' => ->(req) { GeolocationsController.new.resolve(req) }
  }.freeze

  def initialize
    @redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], db: ENV['REDIS_DB'])
  end

  def render_json(data, status = 200)
    [status, { "content-type" => "application/json" }, [data.to_json]]
  end

  def render_400
    [400, { "content-type" => "application/json" }, [{ message: 'Bad request' }.to_json]]
  end
end
