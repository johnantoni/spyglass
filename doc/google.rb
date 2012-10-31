require 'mechanize'
require 'nokogiri'

class WayFair
  attr_accessor :query, :results, :result

  def initialize(q="melissa and doug folding horse stable")
    
    self.result = {}
    self.query = q.to_s.downcase

    agent = Mechanize.new
    agent.get("http://www.wayfair.com")

    frm = agent.page.form_with(:name => "keyword")
    frm.field_with(:id => "ac-mainsearch").value = self.query
    request = agent.submit(frm)

    self.results = agent.page.search("#sbprodgrid li .content")
    
    self.show
  end
  
  def strip(q=self.query)
    return q.gsub(' ', '')
  end
  
  def show
    if !self.results.nil?
      s = self.results.first
      
      self.result["name"] = s.search(".prodname a").text.to_s.downcase
      self.result["price"] = s.search(".bottom .price").text
      
      puts "found #{self.result["name"]} #{self.result["price"]}"
      return true
    else
      return false
    end
  end
      
end

@a = WayFair.new


