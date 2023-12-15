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

  def render_401
    [401, { "content-type" => "application/json" }, [{ message: 'Unauthorized' }.to_json]]
  end

  private

  def authorize_request(req)
    auth_token = req.get_header('HTTP_AUTHORIZATION')&.split&.last

    unless auth_token && auth_token == ENV['APP_AUTH_TOKEN']
      return render_401
    end

    true
  end
end
