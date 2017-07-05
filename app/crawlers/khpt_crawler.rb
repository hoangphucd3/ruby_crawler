class KhptCrawler < Crawler::CrawlerBase
  attr_accessor :category

  BASE_URL = 'http://khoahocphothong.com.vn'

  def crawl
    parse_category_name = category.gsub(/\//, '_')
    valid_product_file_name = "data-holder/khpt/#{parse_category_name.underscore}.csv"
    output_file = CSV.open(valid_product_file_name, 'w')
    output_file << %w[title url image content]

    # Get meta from first page
    first_page = agent.get("#{url}/#{category}")

    last_page_element = parser::HTML(first_page).at_xpath("//ul[@class='pagination']/li[last()]//@href")
    last_page = last_page_element.value.scan(/(?<=[?|\&]p=)\d+/i).first.to_i

    (1..1).each do |page_number|
      page = agent.get("#{url}/#{category}/?p=#{page_number}")

      posts = parser::HTML(page).css('.grid_news .item')

      posts.each do |post|
        link_attributes = post.at('a')
        post_title = link_attributes['title']

        post_detail_elements = agent.get("#{url}#{link_attributes['href']}")
        post_content = parser::HTML(post_detail_elements).css('.the-content .desc').text

        return binding.pry
      end
    end
  end

  def url
    BASE_URL
  end
end