require 'mechanize'
require 'nokogiri'
require 'open-uri' # for url calls


class Crawl

  attr_accessor :param, :results

  def initialize(param)
    self.param = param.to_s.downcase
    self.results = {}
    self.search
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
  
  def get_price(elem)
    begin
      return elem.text.to_s.match(/\d[\d\,\.]+/)[0]
    rescue
      return ""
    end
  end

  def get_text(elem)
    begin
      return elem.text.to_s.strip.downcase
    rescue
      return ""
    end
  end

  def get_attr(elem, attribute)
    begin
      return elem.attr(attribute).to_s.strip.downcase
    rescue
      return ""
    end
  end

  def get_href(elem, base_url)
    begin
      url = elem.attr("href").to_s.strip.downcase
      url = url.match(base_url).nil? ? base_url+url : url
      return url
    rescue
      return ""
    end
  end

end


# -----------------------------------------------------------------------------

class WayFair < Crawl
  
  @@base_url = "http://www.wayfair.com"
  
  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get(@@base_url)
    
      frm = agent.page.form_with(:name => "keyword")
      frm.field_with(:id => "ac-mainsearch").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search("#sbprodgrid li .content")
    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
  end
  
  def attributes(item)
    @attr = {}
    begin
      @attr[:name] = get_text(item.search(".prodname a"))
      @attr[:init_price] = get_price(item.search(".bottom .wasprice .secondarytext"))
      @attr[:sale_price] = get_price(item.search(".bottom .price"))
      @attr[:url] = get_href(item.search(".prodname a"), @@base_url)
    
      puts @attr.inspect
      return @attr

    rescue Exception => e
      puts e.message
      puts e.backtrace
      return {}
    end
  end

end

# -----------------------------------------------------------------------------

class BrookStone < Crawl

  @@base_url = "http://www.brookstone.com"

  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get(@@base_url)

      frm = agent.page.form_with(:name => "search")
      frm.field_with(:id => "frm_text_simple_search").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search(".category_items_container .product_info")

    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
  end
  
  def attributes(item)
    @attr = {}
    begin
      @attr[:name] = get_text(item.search(".prod_title_name a"))
      @attr[:init_price] = ""
      @attr[:sale_price] = get_price(item.search(".price_current:first-child"))
      @attr[:url] = get_href(item.search(".prod_title_name a"), @@base_url)
    
      puts @attr.inspect
      return @attr

    rescue Exception => e
      puts e.message
      puts e.backtrace
      return {}
    end
  end

end

# -----------------------------------------------------------------------------

class OverStock < Crawl

  @@base_url = "http://www.overstock.com"

  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get(@@base_url)

      frm = agent.page.form_with(:id => "search-form")
      frm.field_with(:id => "search-input").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search("#result-products .product")

    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
  end
  
  def attributes(item)
    @attr = {}
    begin
      url = item.css(".pro-thumb").attr("href").value
      doc = Nokogiri::HTML(open(url))
    
      product = doc.css("#prodMain_detail")

      @attr[:name] = get_text(product.css("h1.productName"))
      @attr[:init_price] = ""
      @attr[:sale_price] = get_price(product.css(".price_sale .Ovalue"))
      @attr[:url] = url
    
      puts @attr.inspect
      return @attr

    rescue Exception => e
      puts e.message
      puts e.backtrace
      return {}
    end
  end

end

# -----------------------------------------------------------------------------

class Amazon < Crawl

  @@base_url = "http://www.amazon.com"

  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get(@@base_url)

      frm = agent.page.form_with(:name => "site-search")
      frm.field_with(:id => "twotabsearchtextbox").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search("#atfResults .result.product")

    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
  end
  
  def attributes(item)
    @attr = {}
    begin
      @attr[:name] = get_text(item.css(".data a.title"))
      @attr[:init_price] = get_price(item.css(".data .newPrice strike"))
      @attr[:sale_price] = get_price(item.css(".data .newPrice .price"))
      @attr[:url] = get_href(item.search(".data a.title"), @@base_url)
    
      puts @attr.inspect
      return @attr

    rescue Exception => e
      puts e.message
      puts e.backtrace
      return {}
    end
  end

end

# -----------------------------------------------------------------------------

class NextTag < Crawl

  @@base_url = "http://www.nextag.com"
  
  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get(@@base_url)

      frm = agent.page.form_with(:id => "header-searchform")
      frm.field_with(:id => "searchTop-s2").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search(".sr-results-content .sr-row")
      return @attr

    rescue Exception => e
      puts e.message
      puts e.backtrace
      return {}
    end
  end
    
  def attributes(item)
    @attr = {}
    begin
      @attr[:name] = get_text(item.search(".sr-info a.underline"))
      @attr[:init_price] = ""
      @attr[:sale_price] = get_price(item.search(".op-price-text a.price-link"))
      @attr[:url] = get_href(item.search(".sr-info a.underline"), @@base_url)
    
      puts @attr.inspect
      return @attr

    rescue Exception => e
      puts e.message
      puts e.backtrace
      return {}
    end
  end

end

# -----------------------------------------------------------------------------

class ShopWiki < Crawl

  @@base_url = "http://www.shopwiki.com"

  def search
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get(@@base_url)

      frm = agent.page.form
      frm.field_with(:name => "q").value = self.param
      request = agent.submit(frm)

      self.results = agent.page.search("#search_results tr.offer")

    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
  end
    
  def attributes(item)
    @attr = {}
    begin
      @attr[:name] = get_text(item.search(".offer_cell.title .olink"))
      @attr[:init_price] = ""
      @attr[:sale_price] = get_text(item.search(".offer_cell.price_stuff .olink"))
      @attr[:url] = get_href(item.search(".offer_cell a.olink"), "http://redir.shopwiki.com")
    
      puts @attr.inspect
      return @attr

    rescue Exception => e
      puts e.message
      puts e.backtrace
      return {}
    end
  end

end
