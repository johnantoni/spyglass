require 'rubygems'  
# require 'scrapi'  

# Use built in html parser for scrapi instead of Tidy gem  
# Scraper::Base.parser :html_parser

filename = "codes.csv"

def process_csv (filename)
  require 'csv'
  data = CSV.read filename
  keys = data.shift.map {|i| i.to_s }
  values = data.map {|row| row.map {|cell| cell.to_s } }
  hash_table = values.map {|row| Hash[*keys.zip(row).flatten] }
  return hash_table
end

def google_search (param)
  require 'googleajax'
  GoogleAjax.referer = "http://red91.com"
  results = GoogleAjax::Search.web(param)[:results][0...100]
  results.each do |result|
    puts result[:url].to_s
    puts result[:content].to_s.scan(/(\$[0-9,]+(\.[0-9]{2})?)/)
    puts result[:title_no_formatting]
    puts "-------------------------"    
  end
end

def mechanize_search (param)
  require 'mechanize'
  # param = CGI::escape(param)
  # agent = Mechanize.new
  # agent.get("http://www.google.com/q=#{param}")

  puts param

  # @searchword = params[:q]
  @sitesurl = Array.new
  agent = Mechanize.new
  agent.get("http://www.google.com")
  frm = agent.page.form_with(:name => "f")
  frm.field_with(:name => "q").value = "classic concepts 90187125"
  results = agent.submit(frm)

  # puts search_results.inspect

  agent.page.links_with(:text => /Herri/)

  specify = results.link_with(:text => "classic concepts 90187125")

  puts specify.inspect

  # specify.links.each do |link|
  #     puts link.inspect
  # end  
  # (search_results/"#search li.g").each do |result|
  #   puts result.first.attribute('href')
  #   @sitesurl << (result/"a").first.attribute('href') if result.attribute('class').to_s == 'g knavi'
  # end

  # puts @sitesurl.inspect

  # url = http://www.google.ca/
end

records = process_csv("codes.csv")
# puts records
# puts "-------------------------"    

records.each do |record|
  # param = "#{record['sku']} #{record['name']}"
  param = "#{record['name']} #{record['sku']}"
  mechanize_search(param)
end




# http://asciicasts.com/episodes/173-screen-scraping-with-scrapi



  
# scraper = Scraper.define do
#   array :items
#   process "div.item", :items => Scraper.define {
#     process "a.prodLink", :title => :text, :link => "@href"
#     process "div.priceAvail>div>div.PriceCompare>div.BodyS", :price => :text
#     result :price, :title, :link
#   }
#   result :items
# end
# 
# uri = URI.parse("http://www.walmart.com/search/search-ng.do?search_constraint=0&ic=48_0&search_query=lost+third+season&Find.x=0&Find.y=0&Find=Find")
# scraper.scrape(uri).each do |product|
#   puts product.title
#   puts product.price
#   puts product.link
#   puts
# end



# scraper = Scraper.define do  
#   process "title", :page_name => :text  
#   result :page_name  
# end  
#   
# uri = URI.parse("http://www.walmart.com/search/search-ng.do?search_constraint=0&ic=48_0&search_query=LOST+third+season&Find.x=17&Find.y=1&Find=Find")  
# puts scraper.scrape(uri)


