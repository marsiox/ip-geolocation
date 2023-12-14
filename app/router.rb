require_relative 'controllers/geolocations_controller'

class Router
  ROUTES = {
    '/geolocations' => ->(env) { GeolocationsController.new.resolve(Rack::Request.new(env)) }
  }.freeze

  def call(env)
    route = ROUTES[env['PATH_INFO']]
    route ? route.call(env) : render_404
  end

  def render_404
    [404, { "content-type" => "application/json" }, [{ message: 'Not found' }.to_json]]
  end
end