require 'spec_helper'
require_relative '../../app/controllers/geolocations_controller'

RSpec.describe GeolocationsController do
  include Rack::Test::Methods

  def app
    GeolocationsController.new
  end

  let(:valid_ip) { '123.123.123.123' }
  let(:valid_body) { { ip: valid_ip }.to_json }
  let(:invalid_body) { { ip: 'invalid.ip.addr' }.to_json }
  let(:valid_auth_token) { "Bearer #{ENV['APP_AUTH_TOKEN']}" }
  let(:invalid_auth_token) { "invalid-token" }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => valid_auth_token } }

  describe 'POST /geolocations' do
    context 'valid request' do
      before do
        allow_any_instance_of(Redis).to receive(:hgetall).with(valid_ip).and_return({})
        allow_any_instance_of(Redis).to receive(:hmset).with(valid_ip, :country_name, 'Canada', :city, 'Toronto', :latitude, '1.11111', :longitude, '2.22222')
        allow_any_instance_of(IPStackService).to receive(:retrieve_data).and_return({ 'country_name' => 'Canada', 'city' => 'Toronto', 'latitude' => '1.11111', 'longitude' => '2.22222' })
      end

      it 'returns status code 200' do
        post '/geolocations', valid_body, headers
        expect(last_response.status).to eq(200)
      end

      it 'returns geolocation data' do
        post '/geolocations', valid_body, headers
        expect(last_response.body).to include('Canada')
        expect(last_response.body).to include('Toronto')
        expect(last_response.body).to include('1.11111')
        expect(last_response.body).to include('2.22222')
      end
    end

    context 'invalid request' do
      it 'returns status code 400' do
        post '/geolocations', invalid_body, headers
        expect(last_response.status).to eq(400)
      end
    end

    context 'unauthorized request' do
      it 'returns status code 401' do
        post '/geolocations', valid_body, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => invalid_auth_token }
        expect(last_response.status).to eq(401)
      end
    end
  end
end
