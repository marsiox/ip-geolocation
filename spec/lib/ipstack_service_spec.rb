require 'spec_helper'
require_relative '../../lib/ipstack_service'

RSpec.describe IPStackService do
  describe '#retrieve_data' do
    let(:ip_address) { '123.123.123.123' }
    let(:fake_response) { instance_double('Net::HTTPResponse', body: '{"country_name": "Canada"}', code: '200', is_a?: true) }
    let(:service) { IPStackService.new(ip_address) }

    before do
      allow(Net::HTTP).to receive(:get_response).and_return(fake_response)
    end

    it 'calls Net::HTTP' do
      expected_uri = URI("#{IPStackService::API_BASE_URL}#{ip_address}?access_key=#{ENV['IPSTACK_API_KEY']}")
      service.retrieve_data
      expect(Net::HTTP).to have_received(:get_response).with(expected_uri)
    end

    it 'parses response' do
      expect(service.retrieve_data).to eq({'country_name' => 'Canada'})
    end
  end
end
