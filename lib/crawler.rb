module Crawler
  autoload :Main, 'crawler/main'
  autoload :Threads, 'crawler/threads'
  autoload :ModuleBase, 'crawler/module_base'
  autoload :CrawlerBase, 'crawler/crawler_base'

  def self.setup_env
    setup_load_path
    setup_autoloader
    @mutex = ::Mutex.new
  end

  def self.mutex
    @mutex
  end

  def self.setup_load_path
    $LOAD_PATH << root.join('lib')

    Dir.new(root.join('app')).each do |entry|
      next if entry.eql?('.') ||
              entry.eql?('..') ||
              !File.directory?(root.join('app', entry))

      $LOAD_PATH << root.join('app', entry)
    end
  end

  def self.setup_autoloader
    def Object.const_missing(name)
      Crawler.mutex.synchronize do
        file = name.to_s.underscore
        require file
        klass = const_get(name)
        klass ? klass : raise("Class not found[1]: #{name}")
      end
    end
  end

  def self.root
    @root ||= Pathname.new(File.expand_path('.'))
  end
end

Crawler.setup_env