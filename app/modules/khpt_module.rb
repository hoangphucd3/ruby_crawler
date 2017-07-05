class KhptModule < Crawler::ModuleBase
  def run
    threads = Crawler::Threads.new

    categories.each do |category|
      threads.add do
        crawler = KhptCrawler.new(agent, parser)
        crawler.category = category
        crawler.crawl
      end
    end

    threads.start
  end

  def categories
    YAML.load(File.binread(Crawler.root.join('config', 'khpt.yml')))['categories']
  end
end