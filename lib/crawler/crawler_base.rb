module Crawler
  class CrawlerBase
    attr_reader :agent
    attr_reader :parser

    def self.crawl(*args)
      new(*args).crawl
    end

    # @param httppatry
    def initialize(httppatry, nokogiri)
      @agent = httppatry
      @parser = nokogiri
    end

    # @abstract
    def crawl
      raise 'You must define #crawl method'
    end

    # @param msg [String]
    def log(msg)
      Crawler.mutex.synchronize do
        puts msg
      end
    end
  end
end