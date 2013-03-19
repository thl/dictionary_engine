class SpellingsController < ApplicationController
  #respond_to :json
  
  layout 'stgall'
  helper :habtm
  helper :sort
  include SortHelper

  helper :definitions
  helper :metas



  #Restful update to take care of best_in_place calls
  def update
    @spelling = Spelling.find(params[:id])
    @spelling.update_attributes(params[:spelling])
    respond_with @spelling
  end
  
  def edit_dynamic_spelling
    if(params['internal'] != nil)
      @divname = 'spelling_internal'
    else
    	@divname = 'spelling'
    end
    if params['level'] != nil
      params['level'] = (params['level'].to_i + 1).to_s
    else
      params['level'] = '1'
    end
    @spelling = Spelling.find(params[:id])
    #respond_to do |format|
    #    format.js { render :layout=>false }
    #end
    render :layout=>false
  end
  
  
  def update_dynamic_spelling
    @spelling = Spelling.find(params[:id])
    @temp_definition = @spelling.definition
    #if @spelling.created_by == nil or @spelling.created_by == ""
    #      @spelling.created_by = session[:user].login
    #      @spelling.created_at = Time.now
    #end
    #if session[:user] != nil
    #      @spelling.updated_by = session[:user].login
    #end
    @spelling.updated_at = Time.now
    #if @spelling.update_history == nil
    #    @spelling.update_history = session[:user].login + " ["+Time.now.to_s+"] "
    #else
    #    @spelling.update_history += session[:user].login + " ["+Time.now.to_s+"]  "
    #end
    if @spelling.update_attributes(params[:spelling])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end
  
  def inline_show
    @spelling = Spelling.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_edit
    @spelling = Spelling.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_update
    @spelling = Spelling.find(params[:spelling][:id])
    
    #if @etymology.created_by.blank?
    #   @etymology.created_by = session[:user].login
    #   @etymology.created_at = Time.now
    # end
     #if session[:user] != nil
    #   @etymology.updated_by = session[:user].login
    # end
     #@etymology.updated_at = Time.now
     #if @etymology.update_history == nil
     #  @etymology.update_history = session[:user].login + " ["+Time.now.to_s+"]"
     #else
     #	@etymology.update_history += session[:user].login + " ["+Time.now.to_s+"]"
     #end   
    if @spelling.update_attributes(params[:spelling])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end
  
  
end