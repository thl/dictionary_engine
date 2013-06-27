class TranslationEquivalentsController < ApplicationController
  layout 'stgall'
  helper :habtm
  helper :sort
  include SortHelper

  helper :definitions
  helper :metas
  
  def edit_dynamic
    #@language = []
    #Language.find(:all, :order => 'language asc').each do |l|
    #  @language += [l.language]
    #end
    if(params['internal'] != nil)
      @divname = 'translation_equivalent_internal'
    else
    	@divname = 'translation_equivalent'
    end
    if params['level'] != nil
      params['level'] = (params['level'].to_i + 1).to_s
    else
      params['level'] = '1'
    end
    @translation_equivalent = TranslationEquivalent.find(params[:id])
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end  
 
  def update_dynamic
      @translation_equivalent = TranslationEquivalent.find(params[:id])
      #if params[:translation_equivalent][:language_type_id].blank?
      #   params[:translation_equivalent].delete :language_type_id
      #else
      #   mca_cats = params[:translation_equivalent][:language_type_id].split(',') 
      #   mca_cats.each do |c|
      #     unless c.blank?
      #       params[:translation_equivalent][:language_type_id] = c
      #     end
      #   end
      #end
      if @translation_equivalent.created_by == nil or @translation_equivalent.created_by == ""
        @translation_equivalent.created_by = session[:user].login
        @translation_equivalent.created_at = Time.now
      end
      if session[:user] != nil
        @translation_equivalent.updated_by = session[:user].login
      end
      @translation_equivalent.updated_at = Time.now
      if @translation_equivalent.update_history == nil
        @translation_equivalent.update_history = session[:user].login + " ["+Time.now.to_s+"]
  "
      else
      	@translation_equivalent.update_history += session[:user].login + " ["+Time.now.to_s+"]
  "
      end
      if @translation_equivalent.update_attributes(params[:translation_equivalent])
        respond_to do |format|
          format.js { render :layout=>false }
        end
      end
  end
  
  def inline_show
    @translation_equivalent = TranslationEquivalent.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_edit
    @translation_equivalent = TranslationEquivalent.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  # POST
  def inline_update
    @translation_equivalent = TranslationEquivalent.find(params[:id])
    if @translation_equivalent.created_by.blank?
       @translation_equivalent.created_by = session[:user].login
       @translation_equivalent.created_at = Time.now
     end
    if session[:user] != nil
       @translation_equivalent.updated_by = session[:user].login
     end
     @translation_equivalent.updated_at = Time.now
     if @translation_equivalent.update_history == nil
       @translation_equivalent.update_history = session[:user].login + " ["+Time.now.to_s+"]"
     else
     	@translation_equivalent.update_history += session[:user].login + " ["+Time.now.to_s+"]"
     end   
    if @translation_equivalent.update_attributes(params[:translation_equivalent])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end
  
end