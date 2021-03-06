class PronunciationsController < ApplicationController
#=========== upgraded code to Rails 3 ====
  respond_to :json
  
  
  layout 'stgall'
  helper :habtm
  helper :sort
  include SortHelper

  helper :definitions
  helper :metas


  def edit_dynamic_pronunciation
  # @pronunciation_type = []
  # PronunciationType.find(:all).each do |l|
  #   @pronunciation_type += [l.pronunciation_type]
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
    if(params['internal'] != nil)
      @divname = 'pronunciation_internal'
    else
  	  @divname = 'pronunciation'
    end
    @pronunciation = Pronunciation.find(params[:id])
    ##render :layout => 'staging_popup'
    #render :layout => false
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end  

  def update_dynamic_pronunciation
      @pronunciation = Pronunciation.find(params[:id])
      @temp_definition = Definition.find(@pronunciation.def_id) 
      #if params[:pronunciation][:major_dialect_family_type_id].blank?
      #   params[:pronunciation].delete :major_dialect_family_type_id
      #else
      #   mca_cats = params[:pronunciation][:major_dialect_family_type_id].split(',') 
      #   mca_cats.each do |c|
      #     unless c.blank?
      #       params[:pronunciation][:major_dialect_family_type_id] = c
      #     end
      #   end
      #end
      #if @pronunciation.created_by.blank?
        #@pronunciation.created_by = session[:user].login
       # @pronunciation.created_at = Time.now
      #end
      #if session[:user] != nil
      #  @pronunciation.updated_by = session[:user].login
      #end
      #@pronunciation.updated_at = Time.now
      #if @pronunciation.update_history == nil
      #  @pronunciation.update_history = session[:user].login + " ["+Time.now.to_s+"] "
      #else
      #	@pronunciation.update_history += session[:user].login + " ["+Time.now.to_s+"] "
      #end
      if @pronunciation.update_attributes(params[:pronunciation])
        respond_to do |format|
          format.js { render :layout=>false }
        end
      else
       
      end
    end

  #Restful update to take care of best_in_place calls
  def update
    @pronunciation = Pronunciation.find(params[:id])
    @pronunciation.update_attributes(params[:pronunciation])
    respond_with @definition
  end
  
  def inline_show
    @pronunciation = Pronunciation.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_edit
    @pronunciation = Pronunciation.find(params[:id])
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def inline_update
    @pronunciation = Pronunciation.find(params[:pronunciation][:id])
    
    #if @pronunciation.created_by.blank?
    #   @pronunciation.created_by = session[:user].login
    #   @pronunciation.created_at = Time.now
    # end
     #if session[:user] != nil
    #   @pronunciation.updated_by = session[:user].login
    # end
     #@pronunciation.updated_at = Time.now
     #if @pronunciation.update_history == nil
     #  @pronunciation.update_history = session[:user].login + " ["+Time.now.to_s+"]"
     #else
     #	@pronunciation.update_history += session[:user].login + " ["+Time.now.to_s+"]"
     #end   
    if @pronunciation.update_attributes(params[:pronunciation])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end

  def edit_new
    #  if params['internal'] != nil
    #    internal = params['internal']
    #  else
    #    internal = "pronunciations"
    #  end
    #  if params['level'] != nil
    #    level = params['level'].to_i + 1
    #  else
    #  	 level = '2'
    #  end
      @pronunciation = Pronunciation.find(params['id'])
      @pronunciation.updated_by = session[:user].login
      @pronunciation.updated_at = Time.now
      if @pronunciation.update_history == nil
        @pronunciation.update_history = session[:user].login + " ["+Time.now.to_s+"]
  "
      else
      	@pronunciation.update_history += session[:user].login + " ["+Time.now.to_s+"]
  "
      end
      @pronunciation.save
     # if params["relatedtype"] == "definition"
    #    o = Definition.new
    #    o.save
    #    @pronunciation.definition = o
    #    @pronunciation.save
    #    render_component :controller => "definitions", :action => "edit_dynamic", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'definition', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
    #  end
    if params["relatedtype"] == "meta"
      o = Meta.new
      o.created_by = session[:user].login
      o.created_at = Time.now
      o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
      o.save
      @pronunciation.meta = o
      @pronunciation.save
      redirect_to edit_dynamic_meta_url(o.id)
    end
  end
#=========== end of upgraded code to Rails 3 ====


end