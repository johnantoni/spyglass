require 'rubygems'  
require 'nokogiri'  
require 'mechanize'

agent = Mechanize.new
agent.get("http://www.google.ca")
frm = agent.page.form_with(:name => "f")
frm.field_with(:name => "q").value = "classic concepts 90187125"

s = agent.page.links_with(:text => /Herri/)

