class LazadaCrawler < Crawler::CrawlerBase
  attr_accessor :category

  BASE_URL = 'http://www.lazada.vn'

  def crawl
    valid_product_file_name = "data-holder/lazada/product_#{category.underscore}.csv"
    output_file = CSV.open(valid_product_file_name, 'w')
    output_file << ['product_title', 'product_url', 'product_image', 'product_price', 'product_details']

    # Get meta info from first page
    first_page = agent.get("#{url}/#{category}/?itemperpage=120")

    last_page_element = parser::HTML(first_page).at_xpath("//div[@class='c-paging']//a[@class='c-paging__link'][last()]//@href")
    last_page = last_page_element.value.scan(/(?<=[?|\&]page=)\d+/i)[0].to_i

    (1..last_page).each do |page_number|
      page = agent.get("#{url}/#{category}/?itemperpage=120&page=#{page_number}")

      products_list = parser::HTML(page).xpath('//script[@type="application/ld+json"]')
      products_list.each do |node|
        json_ld = JSON.parse(node.text)
        next if json_ld['@type'] != 'ItemList'
        products = json_ld['itemListElement']

        products.each do |product|
          # https://www.reddit.com/r/ruby/comments/3nvvhk/help_stumped_dealing_with_embedded_quotes_in_csv/?st=j4nqx8et&sh=bc62e42f
          product_name = product['name'].gsub(/[\n(?<!^|,)"(?!,|$)]/, ' ')

          log '=' * 100
          log "Processing #{product_name} - Page: #{page_number}/#{last_page}".yellow

          product_url = product['url'].gsub(/(\?.+)/, '')
          product_price = (product['offers']['price'].to_i)/22000

          product_detail_elements = agent.get(product_url)
          product_desc = parser::HTML(product_detail_elements).css('#productDetails').text
          product_image_element = parser::HTML(product_detail_elements).css('#productZoom')
          product_image = product_image_element.present? ? product_image_element[0]['data-zoom-image'] : ''

          output_file << [product_name, product_url, product_image, product_price, product_desc]

          log "Saved #{product_name} - Page: #{page_number}/#{last_page}".yellow
          log '=' * 100
        end
      end
    end
  end

  def url
    BASE_URL
  end
end