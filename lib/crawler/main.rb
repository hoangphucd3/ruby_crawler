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
        generate_module_data_folder(module_name)
        run_module(module_name)
      end
    end

    protected

    # @param name [String]
    def generate_module_data_folder(name)
      dir = "#{Crawler.root}/data-holder/#{name}"
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
    end

    # @param name [String]
    # @return [void]
    def run_module(name)
      name = "#{name}_module"

      Object.const_get(name.camelize).run
    end

  end
end