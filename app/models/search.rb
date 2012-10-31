class Search < ActiveRecord::Base

  validates :term, :presence => true
  
end
