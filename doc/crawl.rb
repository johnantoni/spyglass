require 'mechanize'
require 'nokogiri'
require 'open-uri' # for url calls


class Crawl

  attr_accessor :param, :results

  def initialize(param)
    self.param = param.to_s.downcase
    self.results = {}
  end

  def search
  end

  def details
    if !self.results.nil?
      @item = self.attributes(self.results.first)
    end
    return @item
  end

  private

  def purge_spaces(param)
    return param.gsub(' ', '')
  end
  
  def get_price(str)
    return str.match(/\d[\d\,\.]+/)[0]
  end

  def get_text(str)
    return str.strip.downcase
  end

end


# -----------------------------------------------------------------------------

class WayFair < Crawl
  
  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get("http://www.wayfair.com")
    
      frm = agent.page.form_with(:name => "keyword")
      frm.field_with(:id => "ac-mainsearch").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search("#sbprodgrid li .content")
    rescue
      # rescue
    end
  end
  
  def attributes(item)
    @attr = {}
    begin
      @attr["name"] = get_text(item.search(".prodname a").text.to_s)
      @attr["init_price"] = get_price(item.search(".bottom .wasprice .price").text.to_s)
      @attr["sale_price"] = get_price(item.search(".bottom .price").text.to_s)
    
      puts "found #{@attr["name"]} #{@attr["init_price"]} #{@attr["sale_price"]}"
    rescue
      # rescue
    end
    return @attr
  end

end

# -----------------------------------------------------------------------------

class BrookStone < Crawl

  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get("http://www.brookstone.com")

      frm = agent.page.form_with(:name => "search")
      frm.field_with(:id => "frm_text_simple_search").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search(".category_items_container .product_info")
    rescue
      # rescue
    end
  end
  
  def attributes(item)
    @attr = {}
    begin
      @attr["name"] = get_text(item.search(".prod_title_name a").text.to_s)
      @attr["init_price"] = ""
      @attr["sale_price"] = get_price(item.search(".price_current:first-child").text.to_s)
    
      puts "found #{@attr["name"]} #{@attr["init_price"]} #{@attr["sale_price"]}"
    rescue
      # rescue
    return @attr
  end

end

# -----------------------------------------------------------------------------

class OverStock < Crawl

  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get("http://www.overstock.com")

      frm = agent.page.form_with(:id => "search-form")
      frm.field_with(:id => "search-input").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search("#result-products .product")
    rescue
      # rescue
    end
  end
  
  def attributes(item)
    @attr = {}
    begin
      url = item.css(".pro-thumb").attr("href").value
      doc = Nokogiri::HTML(open(url))
    
      product = doc.css("#prodMain_detail")

      @attr["name"] = get_text(product.css("h1.productName").text.to_s)
      @attr["init_price"] = ""
      @attr["sale_price"] = get_price(product.css(".price_sale .Ovalue").text.to_s)
    
      puts "found #{@attr["name"]} #{@attr["init_price"]} #{@attr["sale_price"]}"
    rescue
      # rescue
    return @attr
  end

end

# -----------------------------------------------------------------------------

class Amazon < Crawl

  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get("http://www.amazon.com")

      frm = agent.page.form_with(:name => "site-search")
      frm.field_with(:id => "twotabsearchtextbox").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search("#atfResults .result.product")
    rescue
      # rescue
    end
  end
  
  def attributes(item)
    @attr = {}
    begin
      @attr["name"] = get_text(item.css(".data a.title").text.to_s)
      @attr["init_price"] = get_price(item.css(".data .newPrice strike").text.to_s)
      @attr["sale_price"] = get_price(item.css(".data .newPrice .price").text.to_s)
    
      puts "found #{@attr["name"]} #{@attr["init_price"]} #{@attr["sale_price"]}"
    rescue
      # rescue
    return @attr
  end

end

# -----------------------------------------------------------------------------

class NextTag < Crawl
  
  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get("http://www.nextag.com")

      frm = agent.page.form_with(:id => "header-searchform")
      frm.field_with(:id => "searchTop-s2").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search(".sr-results-content .sr-row")
    rescue
      # rescue
    end
  end
    
  def attributes(item)
    @attr = {}
    begin
      @attr["name"] = get_text(item.search(".sr-info a.underline").attr("value").to_s)
      @attr["init_price"] = ""
      @attr["sale_price"] = get_price(item.search(".op-price-text a.price-link").text.to_s)
    
      puts "found #{@attr["name"]} #{@attr["init_price"]} #{@attr["sale_price"]}"
    rescue
      # rescue
    return @attr
  end

end

# -----------------------------------------------------------------------------

class ShopWiki < Crawl
  
  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get("http://www.shopwiki.com")

      frm = agent.page.form
      frm.field_with(:name => "q").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search("#search_results tr.offer")
    rescue
      # rescue
    end
  end
    
  def attributes(item)
    @attr = {}
    begin
      @attr["name"] = get_text(item.search(".offer_cell.title .olink").text.to_s)
      @attr["init_price"] = ""
      @attr["sale_price"] = get_text(item.search(".offer_cell.price_stuff .olink").text.to_s)
    
      puts "found #{@attr["name"]} #{@attr["init_price"]} #{@attr["sale_price"]}"
    rescue
      # rescue
    return @attr
  end

end
