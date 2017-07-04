require 'httparty'
require 'nokogiri'

module Crawler
  class ModuleBase
    attr_reader :agent
    attr_reader :parser

    def self.run(*args)
      new(*args).run
    end

    def initialize
      init_agent
      init_parser
    end

    def init_agent
      @agent = HTTParty
    end

    def init_parser
      @parser = Nokogiri
    end

    # @abstract
    def run
      raise 'You must define #run method'
    end
  end
end