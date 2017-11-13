class OldDefinitionsController < ApplicationController
  respond_to :json
  
  def edit_dynamic
    if(params['internal'] != nil)
      @divname = 'old_definition_internal'
    else
    	@divname = 'old_definition'
    end
    if params['level'] != nil
      params['level'] = (params['level'].to_i + 1).to_s
    else
      params['level'] = '1'
    end
    @old_definition = OldDefinition.find(params[:id])

    #render :layout => false  #due to ui
    respond_to do |format|
         format.js { render :layout=>false }
     end
  end
  
  def update_dynamic
    @old_definition = OldDefinition.find(params[:id])
      
        if @old_definition.created_by == nil or @old_definition.created_by == ""
          @old_definition.created_by = session[:user].login
          @old_definition.created_at = Time.now
        end
        if session[:user] != nil
          @old_definition.updated_by = session[:user].login
        end
        @old_definition.updated_at = Time.now
        if @old_definition.update_history == nil
          @old_definition.update_history = session[:user].login + " ["+Time.now.to_s+"]
    "
        else
          @old_definition.update_history += session[:user].login + " ["+Time.now.to_s+"]
    "
        end

        #related to other dictionaries

    @definition = Definition.find(params[:head_id])
    @head_id = @definition.id
         val = @definition.term
           space = Unicode::U0F0B
           space2 = Unicode::U0F0C
           line = Unicode::U0F0D
           nb_space = Unicode::U00A0
           val = val.strip
           # val = val.gsub("#{nb_space}",' ')  #remove non-breaking space before tsheg

           val = val.gsub(line,'')
           val = val.gsub(space2,space)
            val = val.gsub(space,'_space_')
            a = val.split('_space_')
            word = ''
            a.each {|w| 
              word += space if word != ''
              word += w 
            }
            val = word                  
            val = word.gsub("'","''")

    @dan_martin_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Dan Martin Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
    @ives_waldo_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Ives Waldo Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
    @jeffrey_hopkins_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jeffrey Hopkins Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
    @jim_valby_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jim Valby Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
    @richard_baron_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Richard Barron Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
    @rangjung_yeshe_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Rangujung Yeshe Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
    @yogacara_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Yogācāra Glossary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
    @tshig_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'bod rgya tshig mdzod chen mo' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")

    if @old_definition.update_attributes(params[:old_definition])
      respond_to do |format|
        format.js { render :layout=>false }
      end
    end
  end
  
  def inline_show
     @old_definition = OldDefinition.find(params[:id])
     #render :partial => "old_definition_show", :locals => {:d => @old_definition}
     respond_to do |format|
       format.js { render :layout=>false }
     end
   end

   def inline_edit
     @old_definition = OldDefinition.find(params[:id])
     respond_to do |format|
       format.js { render :layout=>false }
     end
   end

   def inline_update
     @old_definition = OldDefinition.find(params[:old_definition][:id])

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
     if @old_definition.update_attributes(params[:old_definition])
       respond_to do |format|
         format.js { render :layout=>false }
       end
     end
   end
end