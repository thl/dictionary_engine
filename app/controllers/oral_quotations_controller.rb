class OralQuotationsController < ApplicationController
  respond_to :json
    
  helper :definitions
  helper :metas
  helper :translations

  def edit_dynamic
    #if(params['internal'] != nil)
    #  @divname = 'oral_quotation_internal'
    #else
    #	@divname = 'oral_quotation'
    #end
    #if params['level'] != nil
    #  params['level'] = (params['level'].to_i + 1).to_s
    #else
    #  params['level'] = '1'
    #end
    @oral_quotation = OralQuotation.find(params[:id])
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end  

  def update_dynamic
      @oral_quotation = OralQuotation.find(params[:id])
      @temp_definition = Definition.find(@oral_quotation.definitions.first.id)
     
      #if params[:oral_quotation][:source_speaker_dialect_type_id].blank?
      #   params[:oral_quotation].delete :source_speaker_dialect_type_id
      #else
      #   mca_cats = params[:oral_quotation][:source_speaker_dialect_type_id].split(',') 
      #   mca_cats.each do |c|
      #     unless c.blank?
      #       params[:oral_quotation][:source_speaker_dialect_type_id] = c
      #     end
      #   end
      #end
      if @oral_quotation.created_by == nil or @oral_quotation.created_by == ""
        @oral_quotation.created_by = session[:user].login
        @oral_quotation.created_at = Time.now
      end
      if session[:user] != nil
        @oral_quotation.updated_by = session[:user].login
      end
      @oral_quotation.updated_at = Time.now
      if @oral_quotation.update_history == nil
        @oral_quotation.update_history = session[:user].login + " ["+Time.now.to_s+"]
  "
      else
      	@oral_quotation.update_history += session[:user].login + " ["+Time.now.to_s+"]
  "
      end
      if @oral_quotation.update_attributes(params[:oral_quotation])
        respond_to do |format|
          format.js { render :layout=>false }
        end
      end
  end
  
  def inline_show
    @oral_quotation = OralQuotation.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_edit
    @oral_quotation = OralQuotation.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  # POST
  def inline_update
    @oral_quotation = OralQuotation.find(params[:id])
    if @oral_quotation.created_by.blank?
       @oral_quotation.created_by = session[:user].login
       @oral_quotation.created_at = Time.now
     end
    if session[:user] != nil
       @oral_quotation.updated_by = session[:user].login
     end
     @oral_quotation.updated_at = Time.now
     if @oral_quotation.update_history == nil
       @oral_quotation.update_history = session[:user].login + " ["+Time.now.to_s+"]"
     else
     	@oral_quotation.update_history += session[:user].login + " ["+Time.now.to_s+"]"
     end   
    if @oral_quotation.update_attributes(params[:oral_quotation])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end

    
    #used for new oral_quotation->translation
    def edit_new
      #if params['internal'] != nil
      #  internal = params['internal']
      #else
      #  internal = "oral_quotation"
      #end
      #if params['level'] != nil
      #  level = params['level'].to_i + 1
      #else
      #	 level = '2'
      #end
      @oral_quotation = OralQuotation.find(params['id'])
      @oral_quotation.updated_by = session[:user].login
      @oral_quotation.updated_at = Time.now
      if @oral_quotation.update_history == nil
        @oral_quotation.update_history = session[:user].login + " ["+Time.now.to_s+"]
  "
      else
      	@oral_quotation.update_history += session[:user].login + " ["+Time.now.to_s+"]
  "
      end
      @oral_quotation.save
      #if params["relatedtype"] == "definition"
      #  o = Definition.new
      #  o.save
      #  @oral_quotation.definition = o
      #  @oral_quotation.save
      #  render_component :controller => "definitions", :action => "edit_dynamic", :id => o.id, :params => {'internal' => "oral_quotations", 'pk' => params['id'], 'relatedtype'=> 'definition', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
      #end
      if params["relatedtype"] == "meta"
        o = Meta.new
        o.created_by = session[:user].login
        o.created_at = Time.now
        o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
        o.save
        @oral_quotation.meta = o
        @oral_quotation.save
        redirect_to edit_dynamic_meta_url(o.id)
      end
      if params["relatedtype"] == "translation"
        o = Translation.new
        o.created_by = session[:user].login
        o.created_at = Time.now
        o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
        o.save
        @oral_quotation.translations << o
        #render_component :controller => "translations", :action => "edit_dynamic", :id => o.id, :params => {'internal' => "edit_box", 'pk' => params['id'], 'relatedtype'=> 'translation', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
        redirect_to edit_dynamic_translation_url(o.id)
      end
    end    

end