require "lib/crawl.rb"

class Sku
  @queue = :sku_queue
  
  def self.perform(search_id)
    @item = Search.find search_id

    @found = WayFair.new(@item.term)
    @result = @found.details
    @item.update_attributes(
      :wayfair_name => @result[:name], 
      :wayfair_init_price => @result[:init_price], 
      :wayfair_sale_price => @result[:sale_price],
      :wayfair_url => @result[:url]
    )

    @found = BrookStone.new(@item.term)
    @result = @found.details
    @item.update_attributes(
      :brookstone_name => @result[:name], 
      :brookstone_init_price => @result[:init_price], 
      :brookstone_sale_price => @result[:sale_price],
      :brookstone_url => @result[:url]
    )

    @found = OverStock.new(@item.term)
    @result = @found.details
    @item.update_attributes(
      :overstock_name => @result[:name], 
      :overstock_init_price => @result[:init_price], 
      :overstock_sale_price => @result[:sale_price],
      :overstock_url => @result[:url]
    )

    @found = Amazon.new(@item.term)
    @result = @found.details
    @item.update_attributes(
      :amazon_name => @result[:name], 
      :amazon_init_price => @result[:init_price], 
      :amazon_sale_price => @result[:sale_price],
      :amazon_url => @result[:url]
    )

    @found = NextTag.new(@item.term)
    @result = @found.details
    @item.update_attributes(
      :nexttag_name => @result[:name], 
      :nexttag_init_price => @result[:init_price], 
      :nexttag_sale_price => @result[:sale_price],
      :nexttag_url => @result[:url]
    )

    @found = ShopWiki.new(@item.term)
    @result = @found.details
    @item.update_attributes(
      :shopwiki_name => @result[:name], 
      :shopwiki_init_price => @result[:init_price], 
      :shopwiki_sale_price => @result[:sale_price],
      :shopwiki_url => @result[:url]
    )

  end
  
end
