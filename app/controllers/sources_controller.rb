class SourcesController < ApplicationController
  respond_to :json
  
  helper :metas
  
  def edit_dynamic
    #if(params['internal'] != nil)
    #  @divname = 'source_internal'
    #else
    #	@divname = 'source'
    #end
    #if params['level'] != nil
    #  params['level'] = (params['level'].to_i + 1).to_s
    #else
    #  params['level'] = '1'
    #end
    @source = Source.find(params[:id])
    #@source_type = []
    #SourceType.find(:all).each do |l|
    #  @source_type += [l.source_type]
    #end  
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end
  
  def update_dynamic
    @source = Source.find(params[:id])
    @temp_meta = Meta.find(@source.metas.first.id)

    if @source.created_by == nil or @source.created_by == ""
      @source.created_by = session[:user].login
      @source.created_at = Time.now
    end
    if session[:user] != nil
      @source.updated_by = session[:user].login
    end
    @source.updated_at = Time.now
    if @source.update_history == nil
      @source.update_history = session[:user].login + " ["+Time.now.to_s+"]
      "
    else
      @source.update_history += session[:user].login + " ["+Time.now.to_s+"]
      "
    end      
    if @source.update_attributes(params[:source])
      #respond_to do |format|
      #  format.js { render :layout=>false }
      #end
      redirect_to :controller => "definitions", :action => 'public_edit', :id => params['head_id']
      
    end
  end
  
  def inline_show
    @source = Source.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_edit
    @source = Source.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  # POST
  def inline_update
    @source = Source.find(params[:id])
    if @source.created_by.blank?
       @source.created_by = session[:user].login
       @source.created_at = Time.now
     end
    if session[:user] != nil
       @source.updated_by = session[:user].login
     end
     @source.updated_at = Time.now
     if @source.update_history == nil
       @source.update_history = session[:user].login + " ["+Time.now.to_s+"]"
     else
     	@source.update_history += session[:user].login + " ["+Time.now.to_s+"]"
     end   
    if @source.update_attributes(params[:source])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end
  
  
end