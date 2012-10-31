class Grab < ActiveRecord::Base

  validates :url, :presence => true

  before_save :find_by_url
    
  def find_by_url
    logger.debug "path: #{self.url}"
    unless self.url.nil?
      agent = mechanize(self.url)
      begin
        case self.url
        when /macys.com/
          get_macys(agent)
        when /bloomingdales.com/
          get_bloomingdales(agent)
        when /sears.ca/
          get_sears(agent)
        when /www.amazon/
          get_amazon(agent)
        end
      rescue Exception => e
        logger.debug e.message
        logger.debug e.backtrace
      end
    end
  end

  private

  def mechanize(url)
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.read_timeout=2  #set the agent time out
      agent.get(url)
      return agent
    rescue Exception => e
      puts e.message
      puts e.backtrace
      return {}
    end
  end

  def get_macys(agent)
    # http://www1.macys.com/catalog/product/index.ognc?ID=588960&PseudoCat=se-xx-xx-xx.esn_results
    unless agent.nil?
      self.file_type = "tiff"
      loc = agent.page.search(".productImageSection #productFlash img").attr("src").value
      self.asset_path = loc.match(/.*?\?/)[0] + "?op_sharpen=1&wid=800&hei=980"
      logger.debug self.asset_path
    end
  end

  def get_bloomingdales(agent)
    # http://www1.bloomingdales.com/catalog/product/index.ognc?ID=554341&CategoryID=15915
    unless agent.nil?
      logger.debug agent
      self.file_type = "tiff"
      loc = agent.page.search("#mainProductImage").attr("src").value
      logger.debug loc
      self.asset_path = loc.match(/.*?\?/)[0] + "?op_sharpen=1&wid=800&hei=980"
      logger.debug self.asset_path
    end
  end

  def get_sears(agent)
    # http://www.sears.ca/product/protocol-md-long-sleeve-striped-dress-shirt/645-000148783-MF11-PR10-4306
    unless agent.nil?
      self.file_type = "jpg"
      loc = agent.page.search("#productInfo .medium").attr("src").value
      self.asset_path = loc.gsub("Product_271", "Product_437")
    end
  end
  
  def get_amazon(agent)
    # http://www.amazon.ca/gp/product/B00005JM5Z/ref=s9_pop_gw_g74_ir03?pf_rd_m=A3DWYIK6Y9EEQB&pf_rd_s=center-2&pf_rd_r=1T2JV4JEJDCFSA3XXVKK&pf_rd_t=101&pf_rd_p=506427871&pf_rd_i=915398
    unless agent.nil?
      self.file_type = "jpg"
      loc = agent.page.search("#prodImage").attr("src").value
      self.asset_path = loc.gsub("._SL500_AA300_", "")
    end
  end

end