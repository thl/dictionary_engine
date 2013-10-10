class DefinitionDefinitionFormsController < ApplicationController
 respond_to :json
 
  helper :definitions
 
 
  # Related Terms -> step 1    
  def related_term_search  
      
    #if params['internal'] != nil
    #  internal = params['internal']
    #else
    #  internal = "definitions"
    #end
    #if params['level'] != nil
    #  level = params['level'].to_i + 1
    #else
    #	 level = '2'
    #end
    @definition = Definition.find(params['id'])
    @definition.updated_by = session[:user].login
    @definition.updated_at = Time.now
    if @definition.update_history == nil
      @definition.update_history = session[:user].login + " ["+Time.now.to_s+"]
"
    else
    	@definition.update_history += session[:user].login + " ["+Time.now.to_s+"]
"
    end
    @definition.save

    
    #if params["relatedtype"] == "definition_definition_form_from"
      o = DefinitionDefinitionForm.new
      o.relationship_to = params['role_to']
      o.relationship_from = params['role_from']
      o.created_by = session[:user].login
      o.created_at = Time.now
      o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
      o.save
      @definition.definition_definition_form_froms << o
     #redirect_to new_search_definition_definition_forms_url(o.id, :internal => internal, :pk => params['id'], :relatedtype => 'definition_to', :level => params['level'], :new => 'yes', :definition_id => params['definition_id'] )  
      @definition_definition_form = DefinitionDefinitionForm.find(o.id)
      @relatedtype = 'definition_to'
    #end    
    
    respond_to do |format|
        format.js { render :layout=>false }
    end 
  end 
  
  
  
  def find_related_terms
    if params['definition_definition_form'].blank?
      @definition_definition_form = DefinitionDefinitionForm.find(params['id'])
    else
      @definition_definition_form = DefinitionDefinitionForm.find(params['definition_definition_form']['id'])
    end
    if params['mode'] != nil 
        @page_class = params['mode']
    else
        @page_class = 'edit'
    end
    if params['items_per_page'] != nil
        items_per_page = params['items_per_page'].to_i
    else
        items_per_page = 50
    end

    if params['query']
       #@query = buildquery(params["query"])
       @query = params['query']
       query = buildquery(params["query"])
       flash["query"] = params["query"]
       # breakpoint
       # if session['query'] != nil and params['paged'] != nil
       #   query = session['query']
       if session['search_type'] != nil
         session['search_type'] = 'term'
       end
       
       if params['current_first_item'] != nil
          first_item = params['current_first_item'].to_f
          calculated_page = (first_item / items_per_page.to_f).ceil
          params['page'] = calculated_page
       else
         #use current params['page'] parameter if any
       end
       
       sort_clause = "sort_order asc"
        
       #@definition_tos = Definition.find :all, :conditions => query
       @definition_pages = Paginator.new self, Definition.count(:conditions => query), items_per_page, params['page']
       @definition_tos = Definition.find :all, :order => sort_clause, :conditions => query, :limit => @definition_pages.items_per_page, :offset => @definition_pages.current.offset
        
       if @definition_pages.item_count != 0
           @pages = (@definition_pages.item_count.to_f / items_per_page.to_f).ceil
           @current_page = (@definition_pages.current.first_item.to_f / @definition_pages.item_count.to_f * @pages).ceil
       else
           @pages = 0
           @current_page = 0
       end
          
        
  else 
    
    query = ""
     @definition_froms = nil
     if params["relatedtype"] == "definition_from"
       @array = []
       params['internal_definition'].each do |key, val| 
         if val != ""
            space = Unicode::U0F0B
            line = Unicode::U0F0D
            val = val.gsub(line,'')
             val = val.gsub(space,'_space_')
             a = val.split('_space_')
             word = ''
             a.each {|w| 
               word += space if word != ''
               word += w 
             }
             val = word                  
           if query != ""
             query = query + " and "
           end
           query = query + key + " ilike ?"
           @array.push("%"+val+"%")
         end
       end
       query = [query]+@array
       if query == [""]
         @definition_froms = Definition.find_all
       else
         @definition_froms = Definition.find :all, :conditions => query
       end
     end
     @definition_tos = nil
     if params["relatedtype"] == "definition_to"
       
       
       vals=""
       query=""
       @array = []
       if params['internal_definition']['term'] != nil and params['internal_definition']['term'] != ''
         val = params['internal_definition']['term'] #params['term']
         if params[:search_field] == 'tibetan'
            key = 'term'
         elsif params[:search_field] == 'wylie'
            key = 'wylie'
         else
            key = 'phonetic'
         end
         session['search_type'] = key
         if query != ""
             query = query + " and "
             vals = vals + ","
         end
         term_value = val
         space = Unicode::U0F0B
         space2 = Unicode::U0F0C
         line = Unicode::U0F0D
         nb_space = Unicode::U00A0

         val = val.gsub("#{nb_space}",' ')  #remove non-breaking space before tsheg

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
        if params['search_type'] == 'anywhere'
            query = query + key + " ilike ?"
            @array.push("%"+val.gsub('/','').strip+"%")
            vals += 'anywhere:'
        elsif params['search_type'] == 'exact'
            query = query +'('+ key + " = ? or "+key+" = ? or "+key+" = ? or "+key+" = ? or "+key+" = ? or "+key+" = ? or "+key+" = ? or "+key+" = ? or "+key+" = ? or "+key+" = ? or "+key+" = ? )"
            @array.push(val.gsub('/','').strip)
            @array.push(val.gsub('/','').strip+line)
            @array.push(val.gsub('/','').strip+space+line)
            @array.push(val.gsub('/','').strip+space)
            @array.push(val.gsub('/','').strip+space2+line)
            @array.push(val.gsub('/','').strip+space2)
            @array.push(val.gsub('/','').strip+' ')
            @array.push(val.gsub('/','').strip+'/')
            @array.push(val.gsub('/','').strip+' /')
            @array.push(val.gsub('/','').strip+"#{nb_space}")
            @array.push(val.gsub('/','').strip+"#{nb_space}/")
            
            vals += 'exact:'
        else params['search_type'] == 'beginning'
            query = query + key + " ilike ?"
            @array.push(val+"%")
            vals += 'beginning:'
        end 
        if params['search_extent'] == nil
            query += ' and ' if query != nil
            query = query + "level = ?"
            @array.push("head term")
            vals += ',' if vals != ''
            vals += 'level:head term'
         end
         
         vals += ',' if vals != ''
         vals = vals + key + ":" + val
          
      end # if params['internal_definition']['term'] != nil
      query = [query]+@array
      
       @query = vals
       
      # previous code
      # @array = []
      # params['internal_definition'].each do |key, val| 
      # if val != ""
      #     if query != ""
      #       query = query + " and "
      #     end
      #     query = query + key + " ilike ?"
      #     @array.push("%"+val+"%")
      #   end
      # end
      # query = [query]+@array
      # #this is a temp fix, will implement a full search for options as on main page
      # query = ["wylie ilike ? and level = ?", "%"+params['internal_definition']['term']+"%", "head term"]
       
       #new paginator code
       #items_per_page = 50
       sort_clause = "sort_order asc"
       
       #debugger
       if query == [""]
         #old code #@definition_tos = Definition.find :all
         @definition_tos = Definition.find :all
       else
         # old code #@definition_tos = Definition.find :all, :conditions => query
         #@definition_tos = Definition.find :all, :conditions => query
         @definition_pages = Paginator.new self, Definition.count(:conditions => query), items_per_page, params['page']
         @definition_tos = Definition.find :all, :order => sort_clause, :conditions => query, :limit => @definition_pages.items_per_page, :offset => @definition_pages.current.offset
         
         if @definition_pages.item_count != 0
            @pages = (@definition_pages.item_count.to_f / items_per_page.to_f).ceil
            @current_page = (@definition_pages.current.first_item.to_f / @definition_pages.item_count.to_f * @pages).ceil
         else
            @pages = 0
            @current_page = 0
         end
       end
       
       
     end
    end #end if query=="" 
  
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end
  
  def add_related_term
    @definition_definition_form = DefinitionDefinitionForm.find(params['id'])
    @definition_definition_form.updated_by = session[:user].login
    @definition_definition_form.updated_at = Time.now
    if @definition_definition_form.update_history == nil
        @definition_definition_form.update_history = session[:user].login + " ["+Time.now.to_s+"]
  "
    else
      	@definition_definition_form.update_history += session[:user].login + " ["+Time.now.to_s+"]
  "
    end
    @definition_definition_form = DefinitionDefinitionForm.find(params['id'])
    @temp_definition = Definition.find(@definition_definition_form.definition_from.id) 
    if params["relatedtype"] == "definition_to"
      if params['tags'] != nil
        @definition_definition_form.definition_to = Definition.find(params['tags'][0])
        @definition_definition_form.save
      end
    end
    
  end
  

  def edit_new
    #if params['internal'] != nil
    #  internal = params['internal']
    #else
    #  internal = "definition_definition_form"
    #end
    #if params['level'] != nil
    #  level = params['level'].to_i + 1
    #else
  #  	 level = '2'
    #end
    @definition_definition_form = DefinitionDefinitionForm.find(params['id'])
    @definition_definition_form.updated_by = session[:user].login
    @definition_definition_form.updated_at = Time.now
    if @definition_definition_form.update_history == nil
      @definition_definition_form.update_history = session[:user].login + " ["+Time.now.to_s+"]
"
    else
    	@definition_definition_form.update_history += session[:user].login + " ["+Time.now.to_s+"]
"
    end
    @definition_definition_form.save
    if params["relatedtype"] == "meta"
      o = Meta.new
      o.created_by = session[:user].login
      o.created_at = Time.now
      o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
      o.save
      @definition_definition_form.meta = o
      @definition_definition_form.save
      redirect_to edit_dynamic_meta_url(o.id)
    end
    #if params["relatedtype"] == "definition_from"
    #  o = Definition.new
    #  o.save
    #  @definition_definition_form.definition_from = o
    #  @definition_definition_form.save
    #  render_component :controller => "definitions", :action => "edit_dynamic", :id => o.id, :params => {'internal' => "definition_definition_forms", 'pk' => params['id'], 'relatedtype'=> 'definition_from', 'level' => params['level'], 'new' => 'yes'}
    #end
    #if params["relatedtype"] == "definition_to"
    #  o = Definition.new
    #  o.save
    #  @definition_definition_form.definition_to = o
    #  @definition_definition_form.save
    #  render_component :controller => "definitions", :action => "edit_dynamic", :id => o.id, :params => {'internal' => "definition_definition_forms", 'pk' => params['id'], 'relatedtype'=> 'definition_to', 'level' => params['level'], 'new' => 'yes'}
    #end
  end  
  
end