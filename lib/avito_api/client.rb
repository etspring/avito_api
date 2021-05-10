# frozen_string_literal: true

module AvitoApi
  # HHTP-обертка для API
  class Client
    include HTTParty
    
    def initialize(options = {})
      @key = AvitoApi.configuration.key
      @options = options
      @options.merge!({headers: { 'Content-Type' => 'application/json' }}) if @options.empty?
    end

    def categories
      get_data("/#{AvitoApi.configuration.endpoints[__method__]}/categories")
    end

    def items(params = {})
      get_data("/#{AvitoApi.configuration.endpoints[__method__]}/items", params)['result']['items'].map { |i|
        AvitoApi::Item.new(i)
      }
    end

    def request(url, params = {})
      get_data(url, params)
    end

    private

    def base_uri
      [AvitoApi.configuration.api_url, 'api'].join('/')
    end

    def get_data(url, query_params = {})
      @result = self.class.get(
        base_uri + url,
        @options.merge!({query: query_params.merge!({ key: @key })})
      )
      @result.parsed_response
    end
  end
end
