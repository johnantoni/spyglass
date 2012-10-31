class AddUrl < ActiveRecord::Migration
  def up
    add_column :searches, :wayfair_url, :string
    add_column :searches, :brookstone_url, :string
    add_column :searches, :overstock_url, :string
    add_column :searches, :amazon_url, :string
    add_column :searches, :nexttag_url, :string
    add_column :searches, :shopwiki_url, :string
  end

  def down
  end
end
