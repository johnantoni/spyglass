class GrabsController < ApplicationController

  layout "images"

  def new
    @grab = Grab.new
  end
  
  def create
    @grab = Grab.create(params[:grab])
    redirect_to :action => 'show', :id => @grab.id
  end

  def show
    @grab = Grab.find(params[:id])

    respond_to do |format|
      format.html
      format.tiff{ generate_asset(@grab) }
      format.jpg{ generate_asset(@grab) }
    end
  end

  def download
    generate_asset(@grab = Grab.find(params[:id]))
  end

  private
  
  def generate_asset(obj)
    require 'open-uri'
    filename = "#{Rails.root}/public/download.#{obj.file_type}"
    File.open(filename, 'wb') do |file|
      file << open(obj.asset_path).read
    end
    send_file filename, :type => "image/#{obj.file_type}", :disposition => "inline"
  end
  
end
