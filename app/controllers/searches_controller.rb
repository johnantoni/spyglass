class SearchesController < ApplicationController

  layout "searches"

  MAILTO = "john@johnantoni.com"

  def index
    @search = Search.new
    @searches = Search.find(:all)

    respond_to do |format|
      format.html
      format.csv { require 'csv' }
    end

  end

  def create
    @search = Search.new(params[:search])
    if @search.save
      Resque.enqueue(Sku, @search.id)
      redirect_to searches_url, :notice => "Searching for #{@search.term}."
    else
      render :action => 'new'
    end
  end
  
  def destroy
    Search.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

  def empty
    Search.destroy_all
    redirect_to searches_url, :notice => "Cleared all searches"
  end
  
end
