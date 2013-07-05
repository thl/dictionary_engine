class ModelSentencesController < ApplicationController
  respond_to :json

  helper :definitions
  helper :metas
  helper :translations
  
  def edit_dynamic
    @type = ["literary","oral"]
    if(params['internal'] != nil)
      @divname = 'model_sentence_internal'
    else
    	@divname = 'model_sentence'
    end
    if params['level'] != nil
      params['level'] = (params['level'].to_i + 1).to_s
    else
      params['level'] = '1'
    end
    @model_sentence = ModelSentence.find(params[:id])
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end
  
  def update_dynamic
    @model_sentence = ModelSentence.find(params[:id])
    @temp_definition = Definition.find(@model_sentence.definitions.first.id) 
          #if params[:model_sentence][:language_type_id].blank?
          #   params[:model_sentence].delete :language_type_id
          #else
          #   mca_cats = params[:model_sentence][:language_type_id].split(',') 
          #   mca_cats.each do |c|
          #     unless c.blank?
          #       params[:model_sentence][:language_type_id] = c
          #     end
          #   end
          #end
          #if params[:model_sentence][:major_dialect_family_type_id].blank?
          #   params[:model_sentence].delete :major_dialect_family_type_id
          #else
          #   mca_cats = params[:model_sentence][:major_dialect_family_type_id].split(',') 
          #   mca_cats.each do |c|
          #     unless c.blank?
          #       params[:model_sentence][:major_dialect_family_type_id] = c
          #     end
          #   end
          #end
          #if params[:model_sentence][:literary_genre_type_id].blank?
          #   params[:model_sentence].delete :literary_genre_type_id
          #else
          #   mca_cats = params[:model_sentence][:literary_genre_type_id].split(',') 
          #   mca_cats.each do |c|
          #     unless c.blank?
          #       params[:model_sentence][:literary_genre_type_id] = c
          #     end
          #   end
          #end
          #if params[:model_sentence][:literary_period_type_id].blank?
          #   params[:model_sentence].delete :literary_period_type_id
          #else
          #   mca_cats = params[:model_sentence][:literary_period_type_id].split(',') 
          #   mca_cats.each do |c|
          #     unless c.blank?
          #       params[:model_sentence][:literary_period_type_id] = c
          #     end
          #   end
          #end
          #if params[:model_sentence][:literary_form_type_id].blank?
          #   params[:model_sentence].delete :literary_form_type_id
          #else
          #   mca_cats = params[:model_sentence][:literary_form_type_id].split(',') 
          #   mca_cats.each do |c|
          #     unless c.blank?
          #       params[:model_sentence][:literary_form_type_id] = c
          #     end
          #   end
          #end
    if @model_sentence.created_by == nil or @model_sentence.created_by == ""
      @model_sentence.created_by = session[:user].login
      @model_sentence.created_at = Time.now
    end
    if session[:user] != nil
      @model_sentence.updated_by = session[:user].login
    end
    @model_sentence.updated_at = Time.now
    if @model_sentence.update_history == nil
      @model_sentence.update_history = session[:user].login + " ["+Time.now.to_s+"]
      "
    else
      @model_sentence.update_history += session[:user].login + " ["+Time.now.to_s+"]
      "
    end      
    if @model_sentence.update_attributes(params[:model_sentence])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end
  
  def inline_show
    @model_sentence = ModelSentence.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_edit
    @model_sentence = ModelSentence.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  # POST
  def inline_update
    @model_sentence = ModelSentence.find(params[:id])
    if @model_sentence.created_by.blank?
       @model_sentence.created_by = session[:user].login
       @model_sentence.created_at = Time.now
     end
    if session[:user] != nil
       @model_sentence.updated_by = session[:user].login
     end
     @model_sentence.updated_at = Time.now
     if @model_sentence.update_history == nil
       @model_sentence.update_history = session[:user].login + " ["+Time.now.to_s+"]"
     else
     	@model_sentence.update_history += session[:user].login + " ["+Time.now.to_s+"]"
     end   
    if @model_sentence.update_attributes(params[:model_sentence])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end
  
  
end