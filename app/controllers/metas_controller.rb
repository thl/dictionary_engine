class MetasController < ApplicationController


  helper :full_synonyms
  helper :definitions
  helper :translations
  helper :oral_quotations
  helper :spellings
  #helper :groups
  helper :model_sentences
  helper :etymologies
  helper :literary_quotations
  helper :pronunciations
  helper :translation_equivalents

  def edit_dynamic
    #if(params['internal'] != nil)
    #  @divname = 'meta_internal'
    #else
    #	@divname = 'meta'
    #end
    #if params['level'] != nil
    #  params['level'] = (params['level'].to_i + 1).to_s
    #else
    #  params['level'] = '1'
    #end
    @meta = Meta.find(params[:id])
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end

  def update_dynamic
    @meta = Meta.find(params[:id])
    #if params[:meta][:project_type_id].blank?
    #   params[:meta].delete :project_type_id
    #else
    #   mca_cats = params[:meta][:project_type_id].split(',') 
    #   mca_cats.each do |c|
    #     unless c.blank?
    #       params[:meta][:project_type_id] = c
    #     end
    #   end
    #end
    #if params[:meta][:language_type_id].blank?
    #   params[:meta].delete :language_type_id
    #else
    #   mca_cats = params[:meta][:language_type_id].split(',') 
    #   mca_cats.each do |c|
    #     unless c.blank?
    #       params[:meta][:language_type_id] = c
    #     end
    #   end
    #end
    if @meta.created_by == nil or @meta.created_by == ""
           @meta.created_by = session[:user].login
           @meta.created_at = Time.now
    end
    if session[:user] != nil
           @meta.updated_by = session[:user].login
    end
    @meta.updated_at = Time.now
    if @meta.update_history == nil
      @meta.update_history = session[:user].login + " ["+Time.now.to_s+"]
     "
    else
      @meta.update_history += session[:user].login + " ["+Time.now.to_s+"]
     "
    end
    if @meta.update_attributes(params[:meta])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end

  def inline_show
    @meta = Meta.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_edit
    @meta = Meta.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  # POST
  def inline_update
    @meta = Meta.find(params[:id])
    if @meta.created_by.blank?
       @meta.created_by = session[:user].login
       @meta.created_at = Time.now
     end
    if session[:user] != nil
       @meta.updated_by = session[:user].login
     end
     @meta.updated_at = Time.now
     if @meta.update_history == nil
       @meta.update_history = session[:user].login + " ["+Time.now.to_s+"]"
     else
     	@meta.update_history += session[:user].login + " ["+Time.now.to_s+"]"
     end   
    if @meta.update_attributes(params[:meta])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end
  
  def edit_new
    #if params['internal'] != nil
    #  internal = params['internal']
    #else
    #  internal = "meta"
    #end
    #if params['level'] != nil
    #  level = params['level'].to_i + 1
    #else
    #	 level = '2'
    #end
    
    @meta = Meta.find(params['id'])
    if params["relatedtype"] == "source"
      o = Source.new
      o.save
      @meta.sources << o
      @meta.save
      redirect_to :controller => "sources", :action => "edit_dynamic", :id => o.id, :internal => "metas", :pk => params['id'], :relatedtype=> 'full_synonym', :level => params['level'], :new => 'yes', :definition_id => params['definition_id']
    end

  end

end