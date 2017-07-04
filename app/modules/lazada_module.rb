class LazadaModule < Crawler::ModuleBase
  def run
    threads = Crawler::Threads.new

    categories.each do |category|
      threads.add do
        crawler = LazadaCrawler.new(agent, parser)
        crawler.category = category
        crawler.crawl
      end
    end

    threads.start
  end

  def categories
    YAML.load(File.binread(Crawler.root.join('config', 'lazada.yml')))['categories']
  end
end