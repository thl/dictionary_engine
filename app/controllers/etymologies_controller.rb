class EtymologiesController < ApplicationController
  layout 'stgall'
  helper :habtm
  helper :sort
  include SortHelper

  helper :definitions
  helper :metas
  helper :translations


  Etymology.content_columns.each do |column|
    in_place_edit_for :etymology, column.name
  end
  Definition.content_columns.each do |column|
    in_place_edit_for :definition, column.name
  end
  #Meta.content_columns.each do |column|
  #  in_place_edit_for :meta, column.name
  #end
  Translation.content_columns.each do |column|
    in_place_edit_for :translation, column.name
  end
  
  def display_history
	  @history = params[:history]
	  render :partial => 'partial/display_history'
	end
  
  def edit_dynamic_etymology
    # @etymology_type = []
    # EtymologyType.find(:all).each do |l|
    #   @etymology_type += [l.etymology_type]
    # end
    # @derivation = []
    # Derivation.find(:all).each do |l|
    #   @derivation += [l.derivation]
    # end
    # @literary_genre = []
    # LiteraryGenre.find(:all).each do |l|
    #   @literary_genre += [l.literary_genre]
    # end
    # @literary_period = []
    # LiteraryPeriod.find(:all).each do |l|
    #   @literary_period += [l.literary_period]
    # end
    # @literary_form = []
    # LiteraryForm.find(:all).each do |l|
    #   @literary_form += [l.literary_form]
    # end
    # @loan_language = []
    # Language.find(:all).each do |l|
    #   @loan_language += [l.language]
    # end
    if(params['internal'] != nil)
      @divname = 'etymology_internal'
    else
    	@divname = 'etymology'
    end
    if params['level'] != nil
      params['level'] = (params['level'].to_i + 1).to_s
    else
      params['level'] = '1'
    end
    @etymology = Etymology.find(params[:id]) 
    ##render :layout => 'staging_popup'
    #render :layout => false
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end

  def update_dynamic_etymology
      @etymology = Etymology.find(params[:id])
      @temp_definition = Definition.find(@etymology.definition_id) 
      #if params[:etymology][:etymology_category_id].blank?
      #   params[:etymology].delete :etymology_category_id
      #else
      #   mca_cats = params[:etymology][:etymology_category_id].split(',') 
      #   mca_cats.each do |c|
      #     unless c.blank?
      #       params[:etymology][:etymology_category_id] = c
      #     end
      #   end
      #end
      #if params[:etymology][:loan_language_type_id].blank?
      #   params[:etymology].delete :loan_language_type_id
      #else
      #   mca_cats = params[:etymology][:loan_language_type_id].split(',') 
      #   mca_cats.each do |c|
      #     unless c.blank?
      #       params[:etymology][:loan_language_type_id] = c
      #     end
      #   end
      #end
      #if params[:etymology][:derivation_type_id].blank?
      #   params[:etymology].delete :derivation_type_id
      #else
      #   mca_cats = params[:etymology][:derivation_type_id].split(',') 
      #   mca_cats.each do |c|
      #     unless c.blank?
      #       params[:etymology][:derivation_type_id] = c
      #     end
      #   end
      #end
      #if params[:etymology][:major_dialect_family_type_id].blank?
      #   params[:etymology].delete :major_dialect_family_type_id
      #else
      #   mca_cats = params[:etymology][:major_dialect_family_type_id].split(',') 
      #   mca_cats.each do |c|
      #     unless c.blank?
      #       params[:etymology][:major_dialect_family_type_id] = c
      #     end
      #   end
      #end
      #if params[:etymology][:literary_genre_type_id].blank?
      #   params[:etymology].delete :literary_genre_type_id
      #else
      #   mca_cats = params[:etymology][:literary_genre_type_id].split(',') 
      #   mca_cats.each do |c|
      #     unless c.blank?
      #       params[:etymology][:literary_genre_type_id] = c
      #     end
      #   end
      #end
      #if params[:etymology][:literary_period_type_id].blank?
      #   params[:etymology].delete :literary_period_type_id
      #else
      #   mca_cats = params[:etymology][:literary_period_type_id].split(',') 
      #   mca_cats.each do |c|
      #     unless c.blank?
      #       params[:etymology][:literary_period_type_id] = c
      #     end
      #   end
      #end
      #if params[:etymology][:literary_form_type_id].blank?
      #   params[:etymology].delete :literary_form_type_id
      #else
      #   mca_cats = params[:etymology][:literary_form_type_id].split(',') 
      #   mca_cats.each do |c|
      #     unless c.blank?
      #       params[:etymology][:literary_form_type_id] = c
      #     end
      #   end
      #end
      
      
      #if @etymology.created_by == nil or @etymology.created_by == ""
      #  @etymology.created_by = session[:user].login
      #  @etymology.created_at = Time.now
      #end
      #if session[:user] != nil
      #  @etymology.updated_by = session[:user].login
      #end
      #@etymology.updated_at = Time.now
      #if @etymology.update_history == nil
      #  @etymology.update_history = session[:user].login + " ["+Time.now.to_s+"] "
      #else
      #  @etymology.update_history += session[:user].login + " ["+Time.now.to_s+"]  "
      #end    
        if @etymology.update_attributes(params[:etymology])
          respond_to do |format|
            format.js { render :layout=>false }
          end
        end
  end
  
  #Restful update to take care of best_in_place calls
  def update
    @etymology = Etymology.find(params[:id])
    @etymology.update_attributes(params[:etymology])
    respond_with @etymology
  end
  
  def inline_show
    @etymology = Etymology.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_edit
    @etymology = Etymology.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_update
    @etymology = Etymology.find(params[:etymology][:id])
    
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
    if @etymology.update_attributes(params[:etymology])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end
  
  
end