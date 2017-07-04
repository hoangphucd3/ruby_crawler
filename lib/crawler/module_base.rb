require 'httparty'

module Crawler
  class ModuleBase
    attr_reader :agent

    def self.run(*args)
      new(*args).run
    end

    def initialize
      init_agent
    end

    def init_agent
      @agent = HTTParty
    end

    # @abstract
    def run
      raise 'You must define #run method'
    end
  end
end