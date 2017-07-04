module Crawler
  class Main
    attr_accessor :modules

    # @param modules [Array]
    # @return [void]
    def initialize(modules)
      @modules = modules
    end

    # @return [void]
    def run
      modules.each do |module_name|
        run_module(module_name)
      end
    end

    protected

    # @param name [String]
    # @return [void]
    def run_module(name)
      name = "#{name}_module"

      Object.const_get(name.camelize).run
    end

  end
end