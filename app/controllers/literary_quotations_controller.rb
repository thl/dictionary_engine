class LiteraryQuotationsController < ApplicationController
  respond_to :json
    
  helper :definitions
  helper :metas
  helper :translations
  
  def edit_dynamic

    @literary_quotation = LiteraryQuotation.find(params[:id])
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end
  
  def update_dynamic
    @literary_quotation = LiteraryQuotation.find(params[:id])
    @temp_definition = Definition.find(@literary_quotation.definitions.first.id)
    #if params[:literary_quotation][:script_type_id].blank?
    #   params[:literary_quotation].delete :script_type_id
    #else
    #   mca_cats = params[:literary_quotation][:script_type_id].split(',') 
    #   mca_cats.each do |c|
    #     unless c.blank?
    #       params[:literary_quotation][:script_type_id] = c
    #     end
    #   end
    #end
    #if params[:literary_quotation][:literary_form_type_id].blank?
    #   params[:literary_quotation].delete :literary_form_type_id
    #else
    #   mca_cats = params[:literary_quotation][:literary_form_type_id].split(',') 
    #   mca_cats.each do |c|
    #     unless c.blank?
    #       params[:literary_quotation][:literary_form_type_id] = c
    #     end
    #   end
    #end
    
    if @literary_quotation.created_by.blank?
       @literary_quotation.created_by = session[:user].login
       @literary_quotation.created_at = Time.now
     end
    if session[:user] != nil
       @literary_quotation.updated_by = session[:user].login
     end
     @literary_quotation.updated_at = Time.now
     if @literary_quotation.update_history == nil
       @literary_quotation.update_history = session[:user].login + " ["+Time.now.to_s+"]"
     else
     	@literary_quotation.update_history += session[:user].login + " ["+Time.now.to_s+"]"
     end   
     if @literary_quotation.update_attributes(params[:literary_quotation])
       respond_to do |format|
         format.js { render :layout=>false }
       end
     end
   end
  
  def inline_show
    @literary_quotation = LiteraryQuotation.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_edit
    @literary_quotation = LiteraryQuotation.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  # POST
  def inline_update
    @literary_quotation = LiteraryQuotation.find(params[:id])
    if @literary_quotation.created_by.blank?
       @literary_quotation.created_by = session[:user].login
       @literary_quotation.created_at = Time.now
     end
    if session[:user] != nil
       @literary_quotation.updated_by = session[:user].login
     end
     @literary_quotation.updated_at = Time.now
     if @literary_quotation.update_history == nil
       @literary_quotation.update_history = session[:user].login + " ["+Time.now.to_s+"]"
     else
     	@literary_quotation.update_history += session[:user].login + " ["+Time.now.to_s+"]"
     end   
    if @literary_quotation.update_attributes(params[:literary_quotation])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end  
  
  def edit_new
  #    if params['internal'] != nil
  #      internal = params['internal']
  #    else
  #      internal = "literary_quotation"
  #    end
  #    if params['level'] != nil
  #      level = params['level'].to_i + 1
  #    else
  #    	 level = '2'
  #    end
    @literary_quotation = LiteraryQuotation.find(params['id'])
    @literary_quotation.updated_by = session[:user].login
    @literary_quotation.updated_at = Time.now
    if @literary_quotation.update_history == nil
      @literary_quotation.update_history = session[:user].login + " ["+Time.now.to_s+"]
  "
    else
      @literary_quotation.update_history += session[:user].login + " ["+Time.now.to_s+"]
  "
    end
    @literary_quotation.save
    #  if params["relatedtype"] == "definition"
    #    o = Definition.new
    #    o.save
    #    @literary_quotation.definitions << o
    #    # @literary_quotation.save
    #    render_component :controller => "definitions", :action => "edit_dynamic", :id => o.id, :params => {'internal' => "literary_quotations", 'pk' => params['id'], 'relatedtype'=> 'definition', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
    #  end
    if params["relatedtype"] == "meta"
      o = Meta.new
      o.created_by = session[:user].login
      o.created_at = Time.now
      o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
      o.save
      @literary_quotation.meta = o
      @literary_quotation.save
      redirect_to edit_dynamic_meta_url(o.id)
    end
    if params["relatedtype"] == "translation"
      o = Translation.new
      o.created_by = session[:user].login
      o.created_at = Time.now
      o.save
      @literary_quotation.translations << o
      redirect_to edit_dynamic_translation_url(o.id)
    end
  end
  
end