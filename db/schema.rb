# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111202234538) do

  create_table "grabs", :force => true do |t|
    t.string "url"
    t.string "file_type"
    t.string "asset_path"
  end

  create_table "searches", :force => true do |t|
    t.string   "term"
    t.string   "wayfair_name"
    t.string   "wayfair_init_price"
    t.string   "wayfair_sale_price"
    t.string   "brookstone_name"
    t.string   "brookstone_init_price"
    t.string   "brookstone_sale_price"
    t.string   "overstock_name"
    t.string   "overstock_init_price"
    t.string   "overstock_sale_price"
    t.string   "amazon_name"
    t.string   "amazon_init_price"
    t.string   "amazon_sale_price"
    t.string   "nexttag_name"
    t.string   "nexttag_init_price"
    t.string   "nexttag_sale_price"
    t.string   "shopwiki_name"
    t.string   "shopwiki_init_price"
    t.string   "shopwiki_sale_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wayfair_url"
    t.string   "brookstone_url"
    t.string   "overstock_url"
    t.string   "amazon_url"
    t.string   "nexttag_url"
    t.string   "shopwiki_url"
  end

end
