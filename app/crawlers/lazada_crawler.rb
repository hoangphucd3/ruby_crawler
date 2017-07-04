class LazadaCrawler < Crawler::CrawlerBase
  attr_accessor :category

  BASE_URL = 'http://www.lazada.vn/'

  def crawl
    page = agent.get("#{url}#{category}/?itemperpage=120")

    products_list = parser::HTML(page).xpath('//script[@type="application/ld+json"]')

    products_list.each do |node|
      json_ld = JSON.parse(node.text)
      next if json_ld['@type'] != 'ItemList'
      products = json_ld['itemListElement']
      valid_product_file_name = "product_#{category.underscore }.csv"

      CSV.open(valid_product_file_name, 'wb') do |csv|
        csv << ['product_title', 'product_url', 'product_image', 'product_price', 'product_details']
        products.each do |product|
          # https://www.reddit.com/r/ruby/comments/3nvvhk/help_stumped_dealing_with_embedded_quotes_in_csv/?st=j4nqx8et&sh=bc62e42f
          product_name = product['name'].gsub(/[\n(?<!^|,)"(?!,|$)]/, ' ')
          product_url = product['url'].gsub(/(\?.+)/, '')
          product_price = (product['offers']['price'].to_i)/22000

          product_detail_elements = agent.get(product_url)
          product_desc = parser::HTML(product_detail_elements).css('#productDetails').text
          product_image = parser::HTML(product_detail_elements).css('#productZoom')[0]['data-zoom-image']

          csv << [product_name, product_url, product_image, product_price, product_desc]

          log "Saved #{product_name}"
        end
      end
    end
  end

  def url
    BASE_URL
  end
end