class BrowseController < ApplicationController
  #layout 'staging_new'
  
  def index
    #render :file => Rails.root.join("tmp/page_#{params[:letter]}.rhtml") #"tmp/page_#{params[:letter]}.rhtml"
    @file_path =  Rails.root.join("tmp/page_#{params[:letter]}.rhtml")
    
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end
  
  def clear
    expire_page(:controller => :browse, :action => :index)
    render :text => 'done'
  end
end