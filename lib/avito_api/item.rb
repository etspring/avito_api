# frozen_string_literal: true

module AvitoApi
  # Объявление из ленты.
  # Полное описание как и телефон получаются отдельными запросами.
  class Item
    attr_accessor :raw, :client

    def initialize(json)
      @raw = json
      @raw['value'].each do |var, value|
        self.class.send(:attr_accessor, var)
        instance_variable_set("@#{var}", value)
      end
      @client = AvitoApi::Client.new
    end

    # Телефон можно получить только отдельным запросом.
    def phone
      @phone ||= parse_phone(@client.request("/#{AvitoApi.configuration.endpoints[__method__]}/items/#{@id}/phone"))
    end

    # Аналогично телефону.
    def full
      @full ||= parse_full(@client.request("/#{AvitoApi.configuration.endpoints[__method__]}/items/#{@id}"))
    end

    private

    def parse_full(response)
      response.each do |var, value|
        self.class.send(:attr_accessor, var)
        instance_variable_set("@#{var}", value)
      end
      @full = response
    end

    def parse_phone(response)
      uri = response['result']['action']['uri']
      return '' unless uri

      return '' unless uri.include?('number')

      @phone = uri.split('=%2B').last
    end
  end
end
