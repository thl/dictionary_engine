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
  
  #used for new model_sentence->translation
  def edit_new
   #   if params['internal'] != nil
  #      internal = params['internal']
  #    else
  #      internal = "model_sentence"
  #    end
  #    if params['level'] != nil
  #      level = params['level'].to_i + 1
  #    else
  #    	 level = '2'
  #    end
    @model_sentence = ModelSentence.find(params['id'])
    @model_sentence.updated_by = session[:user].login
    @model_sentence.updated_at = Time.now
    if @model_sentence.update_history == nil
      @model_sentence.update_history = session[:user].login + " ["+Time.now.to_s+"]
  "
    else
      @model_sentence.update_history += session[:user].login + " ["+Time.now.to_s+"]
  "
    end
    @model_sentence.save
    #  if params["relatedtype"] == "definition"
    #    o = Definition.new
    #    o.save
    #    @model_sentence.definition = o
    #    @model_sentence.save
    #    render_component :controller => "definitions", :action => "edit_dynamic", :id => o.id, :params => {'internal' => "model_sentences", 'pk' => params['id'], 'relatedtype'=> 'definition', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
    #  end
    #  if params["relatedtype"] == "meta"
    #    o = Meta.new
    #    o.created_by = session[:user].login
    #    o.created_at = Time.now
    #    o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
    #    o.save
    #    @model_sentence.meta = o
    #    @model_sentence.save
    #    #render_component :controller => "metas", :action => "edit_dynamic", :id => o.id, :params => {'internal' => "edit_box", 'pk' => params['id'], 'relatedtype'=> 'meta', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
    #    redirect_to meta_metadata_edit_dynamic_meta_url(o.id)
    #  end
    if params["relatedtype"] == "translation"
      o = Translation.new
      o.created_by = session[:user].login
      o.created_at = Time.now
      o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
      o.save
      @model_sentence.translations << o
        #render_component :controller => "translations", :action => "edit_dynamic", :id => o.id, :params => {'internal' => "edit_box", 'pk' => params['id'], 'relatedtype'=> 'translation', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
      redirect_to edit_dynamic_translation_url(o.id)
    end
  end
end