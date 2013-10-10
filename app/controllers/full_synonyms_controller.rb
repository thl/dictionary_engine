class FullSynonymsController < ApplicationController
 respond_to :json
 
  helper :definitions
  helper :metas
  
  # Related Terms -> Full Synonym step 1    
  def synonym_search
    
    @definition = Definition.find(params['id'])
    respond_to do |format|
        format.js { render :layout=>false }
    end 
  end
  
  def find_full_synonyms
    
    #previous code
    #@terms = Definition.find(:all, :conditions => "term ilike '%"+params['term']+"%'")
    ##key = 'wylie'
    ##query = ["wylie ilike ? and level = ?", "%"+params['term']+"%", "head term"]
    ##@terms = Definition.find :all, :conditions => query
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

        #@terms = Definition.find :all, :conditions => query
        @definition_pages = Paginator.new self, Definition.count(:conditions => query), items_per_page, params['page']
        @terms = Definition.find :all, :order => sort_clause, :conditions => query, :limit => @definition_pages.items_per_page, :offset => @definition_pages.current.offset

        if @definition_pages.item_count != 0
            @pages = (@definition_pages.item_count.to_f / items_per_page.to_f).ceil
            @current_page = (@definition_pages.current.first_item.to_f / @definition_pages.item_count.to_f * @pages).ceil
        else
            @pages = 0
            @current_page = 0
        end
        
   else 
    query = ""
     
     @definition_tos = nil
     #if params["relatedtype"] == "full_synonym"
       
       
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
    
      items_per_page = 50
      sort_clause = "sort_order asc"
      if query == [""]
         @terms = Definition.find :all
      else
         @terms = Definition.find :all, :conditions => query
         #@definition_tos = Definition.find :all, :conditions => query
         @definition_pages = Paginator.new self, Definition.count(:conditions => query), items_per_page, params['page']
         @terms = Definition.find :all, :order => sort_clause, :conditions => query, :limit => @definition_pages.items_per_page, :offset => @definition_pages.current.offset

        if @definition_pages.item_count != 0
             @pages = (@definition_pages.item_count.to_f / items_per_page.to_f).ceil
             @current_page = (@definition_pages.current.first_item.to_f / @definition_pages.item_count.to_f * @pages).ceil
        else
             @pages = 0
             @current_page = 0
        end
      end
     #end
  end
    
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end  
  
  
  def add_synonym

    term_a = Definition.find(params[:id])
    @temp_definition = Definition.find(params[:id])

    if params['tags'] != nil
      term_b = Definition.find(params['tags'][0])
      if term_a.full_synonyms.size == 0
        puts '-------'
        puts 'a not in group'
        if term_b.full_synonyms.size == 0
          puts '-------'
          puts 'create b group'
          fs = FullSynonym.new
          fs.created_by = session[:user].login
          fs.created_at = Time.now
          fs.save
          term_b.full_synonyms << fs
        end
        fs = term_b.full_synonyms[0]
        fs.definitions << term_a
        fs.updated_by = session[:user].login
        fs.updated_at = Time.now
        if fs.update_history == nil
          fs.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
        else
          fs.update_history += session[:user].login + " ["+Time.now.to_s+"] \n"
        end
        fs.save
 
      else
        for fs in term_a.full_synonyms
          puts '-------'
          puts 'add b to syn group'
          if term_b.full_synonyms.size > 0
            puts '-------'
            puts 'merge syn groups'
            merge_synyonyms = term_b.full_synonyms
            for fs_b in merge_synyonyms
              for s in fs_b.definitions
                puts '-------'
                puts 'add syn to a'
                fs.definitions << s
                fs.updated_by = session[:user].login
                fs.updated_at = Time.now
                if fs.update_history == nil
                  fs.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
                else
                  fs.update_history += session[:user].login + " ["+Time.now.to_s+"] \n"
                end
                fs.save
              end
              # term_a.full_synonyms << fs_b
              if fs_b.meta != nil 
                if fs.meta != nil
                  fs.meta.metadata_note = '' if fs.meta.metadata_note == nil
                  fs.meta.metadata_note += ";\n"+fs_b.meta.metadata_note unless fs_b.meta.metadata_note == nil
                  fs.meta.updated_by = session[:user].login
                  fs.meta.updated_at = Time.now
                  if fs.meta.update_history == nil
                    fs.meta.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
                  else
                    fs.meta.update_history += session[:user].login + " ["+Time.now.to_s+"] \n"
                  end
                  fs.meta.save
                else
                  fs.meta = Meta.new
                  fs.meta.updated_by = session[:user].login
                  fs.meta.updated_at = Time.now
                  if fs.meta.update_history == nil
                    fs.meta.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
                  else
                    fs.meta.update_history += session[:user].login + " ["+Time.now.to_s+"] \n"
                  end
                  fs.meta.metadata_note = '' if fs.meta.metadata_note == nil
                  fs.meta.metadata_note += ";\n"+fs_b.meta.metadata_note
                  fs.meta.save
                end
                for s in fs_b.meta.sources
                  fs.meta.sources << s
                end
              end
              puts '-------'
              puts 'remove b syn group'
              fs_b.destroy
            end
          else
            fs.definitions << term_b
            fs.updated_by = session[:user].login
            fs.updated_at = Time.now
            if fs.update_history == nil
              fs.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
            else
              fs.update_history += session[:user].login + " ["+Time.now.to_s+"] \n"
            end
            fs.save
   
          end
        end
      end
    end
    respond_to do |format|
        format.js { render :layout=>false }
    end
  end
  
  def edit_new
    #  if params['internal'] != nil
    #    internal = params['internal']
    #  else
    #    internal = "full_synonym"
    #  end
    #  if params['level'] != nil
    #    level = params['level'].to_i + 1
    #  else
    #  	 level = '2'
    #  end
      @full_synonym = FullSynonym.find(params['id'])
      @full_synonym.updated_by = session[:user].login
      @full_synonym.updated_at = Time.now
      if @full_synonym.update_history == nil
        @full_synonym.update_history = session[:user].login + " ["+Time.now.to_s+"]
  "
      else
      	@full_synonym.update_history += session[:user].login + " ["+Time.now.to_s+"]
  "
      end
      @full_synonym.save
      #if params["relatedtype"] == "definition"
      #  o = Definition.new
      #  o.save
      #  @full_synonym.definitions << o
      #  render_component :controller => "definitions", :action => "edit_dynamic", :id => o.id, :params => {'internal' => "full_synonyms", 'pk' => params['id'], 'relatedtype'=> 'definition', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
      #end
      if params["relatedtype"] == "meta"
        o = Meta.new
        o.created_by = session[:user].login
        o.created_at = Time.now
        o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
        o.save
        @full_synonym.meta = o
        @full_synonym.save
        redirect_to edit_dynamic_meta_url(o.id)
      end
    end  
  
end