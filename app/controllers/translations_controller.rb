class TranslationsController < ApplicationController
  respond_to :json
  
  helper :definitions
  helper :oral_quotations
  helper :model_sentences
  helper :metas
  helper :etymologies
  helper :literary_quotations
  
  #Restful update to take care of best_in_place calls
  def update
    @translation = Translation.find(params[:id])
    @translation.update_attributes(params[:translation])
    respond_with @translation
  end
  
  def edit_dynamic
    #@language = []
    #Language.find(:all, :order => 'language asc').each do |l|
    #  @language += [l.language]
    #end
    if(params['internal'] != nil)
      @divname = 'translation_internal'
    else
    	@divname = 'translation'
    end
    if params['level'] != nil
      params['level'] = (params['level'].to_i + 1).to_s
    else
      params['level'] = '1'
    end
    @translation = Translation.find(params[:id])
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end
  
  def update_dynamic
      @translation = Translation.find(params[:id])
      ##if params[:translation][:language_type_id].blank?
      ##  params[:translation].delete :language_type_id
      ##else
      ##  mca_cats = params[:translation][:language_type_id].split(',') 
      ##  mca_cats.each do |c|
      ##    unless c.blank?
      ##      params[:translation][:language_type_id] = c
      ##    end
      ##  end
      ##end
      
      #if @translation.created_by == nil or @translation.created_by == ""
      #  @translation.created_by = session[:user].login
      #  @translation.created_at = Time.now
      #end
      #if session[:user] != nil
      #  @translation.updated_by = session[:user].login
      #end
      #@translation.updated_at = Time.now
      #if @translation.update_history == nil
      #  @translation.update_history = session[:user].login + " ["+Time.now.to_s+"]  "
      #else
      #	@translation.update_history += session[:user].login + " ["+Time.now.to_s+"] "
      #end
      
      #now determine who's the parent of the translation to update
        if @translation.definition_id.nil?
          if @translation.etymology_id.nil?
            if @translation.literary_quotation_id.nil?
              if @translation.oral_quotation_id.nil?
                if @translation.model_sentence_id.nil?
                else
                  @parent_element = ModelSentence.find(@translation.model_sentence_id) 
                  @temp_definition = Definition.find(@parent_element.definitions.first.definition_id)
                end
              else
                @parent_element = OralQuotation.find(@translation.oral_quotation_id) 
                @temp_definition = Definition.find(@parent_element.definitions.first.definition_id)
              end
            else
              @parent_element = LiteraryQuotation.find(@translation.literary_quotation_id) 
              @temp_definition = Definition.find(@parent_element.definitions.first.definition_id)
            end
          else
            @parent_element = Etymology.find(@translation.etymology_id) 
            @temp_definition = Definition.find(@parent_element.definition_id)
          end
        else
          @parent_element = Definition.find(@translation.definition_id) 
          @temp_definition = Definition.find(@translation.definition_id) 
        end
              
        respond_to do |format|
          format.js { render :layout=>false }
        end
    end  
    
    def inline_show
      @translation = Translation.find(params[:id])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end

    def inline_edit
      @translation = Translation.find(params[:id])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end

    # POST
    def inline_update
      @translation = Translation.find(params[:id])
      debugger
      if @translation.created_by.blank?
         @translation.created_by = session[:user].login
         @translation.created_at = Time.now
       end
      if session[:user] != nil
         @translation.updated_by = session[:user].login
       end
       @translation.updated_at = Time.now
       if @translation.update_history == nil
         @translation.update_history = session[:user].login + " ["+Time.now.to_s+"]"
       else
       	@translation.update_history += session[:user].login + " ["+Time.now.to_s+"]"
       end   
      if @translation.update_attributes(params[:translation])
        respond_to do |format|
          format.js { render :layout=>false }
        end
      end
    end  
  
end