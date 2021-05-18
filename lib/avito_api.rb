# frozen_string_literal: true

require 'httparty'
require_relative 'avito_api/client'
require_relative 'avito_api/item'
require_relative 'avito_api/version'

# Avito module
module AvitoApi
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  # Avito config
  class Configuration
    attr_accessor :key, :api_url, :endpoints

    def initialize
      @api_url = 'https://www.avito.ru'
      @endpoints = { categories: '5', items: '10', phone: '1', full: '16', slocations: '1' }
    end
  end
end
