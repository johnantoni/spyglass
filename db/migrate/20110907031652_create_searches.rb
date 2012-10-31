class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :term

      t.string :wayfair_name
      t.string :wayfair_init_price
      t.string :wayfair_sale_price

      t.string :brookstone_name
      t.string :brookstone_init_price
      t.string :brookstone_sale_price

      t.string :overstock_name
      t.string :overstock_init_price
      t.string :overstock_sale_price

      t.string :amazon_name
      t.string :amazon_init_price
      t.string :amazon_sale_price

      t.string :nexttag_name
      t.string :nexttag_init_price
      t.string :nexttag_sale_price

      t.string :shopwiki_name
      t.string :shopwiki_init_price
      t.string :shopwiki_sale_price

      t.timestamps
    end
  end
end
