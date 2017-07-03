require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'
require 'csv'
require 'pp'
require 'ruby-progressbar'

print "Enter category slug: "
cat_slug = gets.chomp.to_s

page = HTTParty.get("http://www.lazada.vn/#{cat_slug}/?itemperpage=120")

parse_page = Nokogiri::HTML(page)
parse_page = parse_page.xpath('//script[@type="application/ld+json"]')

progressbar = ProgressBar.create(total: 120)

parse_page.each do |node|
  json_ld = JSON.parse(node.text)
  next if json_ld['@type'] != 'ItemList'
  products = json_ld['itemListElement']
  valid_product_file_name = "product_#{cat_slug.gsub(/-/, '_')}.csv"

  CSV.open(valid_product_file_name, 'wb') do |csv|
    csv << ['product_title', 'product_url', 'product_image', 'product_price', 'product_details']
    products.each do |product|
      # https://www.reddit.com/r/ruby/comments/3nvvhk/help_stumped_dealing_with_embedded_quotes_in_csv/?st=j4nqx8et&sh=bc62e42f
      product_name = product['name'].gsub(/[\n(?<!^|,)"(?!,|$)]/, ' ')
      product_url = product['url'].gsub(/(\?.+)/, '')
      product_price = (product['offers']['price'].to_i)/22000

      product_detail_elements = HTTParty.get(product_url)
      product_desc = Nokogiri::HTML(product_detail_elements).css('#productDetails').text
      product_image = Nokogiri::HTML(product_detail_elements).css('#productZoom')[0]['data-zoom-image']

      csv << [product_name, product_url, product_image, product_price, product_desc]
      progressbar.increment
      # sleep 0.5 + rand
    end
  end
end
