class DefinitionsController < ApplicationController
  respond_to :json

   helper :habtm
   helper :sort
   include SortHelper

   helper :full_synonyms
   helper :definitions
   helper :literary_quotations
   helper :translation_equivalents
   helper :etymologies
   #helper :definitions_definitions
   helper :oral_quotations
   helper :metas
   helper :spellings
   helper :model_sentences
   helper :definition_definition_forms
   helper :translations
   helper :pronunciations



   def home
       @current_tab_id = :custom_home
       @current_section = :home
       #@users = Dictionary::User.find :all, :conditions => 'full_name is not null'
       @users = Dictionary::User.where('full_name is not null')
       @page_class = 'home'    
       render :layout => 'staging_new'
   end
   
   def index
     # list
     # render :action => 'list'
     @current_tab_id = :search  #:home
     @current_section = :home
     @users = Dictionary::User.find :all, :conditions => 'full_name is not null'
     @page_class = 'search'
     render :layout => 'staging_new' #'thdl_home'
   end   
   
   def browse
     @current_tab_id = :browse
     @current_section = :showview
     @alphabet = ComplexScripts::TibetanLetter.all
     expire_page(:controller => :browse, :action => :index)

     render :layout => 'staging_new'
   end
   
   def alphabet_sub_list
     @terms = []
     @definitions = Definition.find( :all, :conditions => {:root_letter_id => params[:letter], :level => 'head term'}, :order => 'sort_order asc', :offset => params[:offset], :limit => 100)
     #above was commented

     #below wasn't commented
     #@definitions = Definition.find(:all, :conditions => ["sort_order >= ? and sort_order <= ? and level = 'head term'", "#{params['start']}","#{params['start'].to_i+params['total'].to_i}"], :order => 'sort_order asc')
     @definitions.each do |d|
       @terms << {:term => "#{d.term.span} #{d.wylie} #{d.phonetic}", :id => d.id}
     end
     render :layout => false
     end
   
   def edit_new
       if params['internal'] != nil
         internal = params['internal']
       else
         internal = "definitions"
       end
       if params['level'] != nil
         level = params['level'].to_i + 1
       else
       	 level = '2'
       end
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

       if params["relatedtype"] == "full_synonym"
         o = FullSynonym.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.save
         @definition.full_synonyms << o
         render_component :controller => "full_synonyms", :action => "public_edit", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'full_synonym', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}

       end
       if params["relatedtype"] == "super_definition"
         o = DefinitionDefinition.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.super_definitions << o
         render_component :controller => "definition_definitions", :action => "edit_dynamic", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'super_definition', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
       end
       if params["relatedtype"] == "literary_quotation"
         o = LiteraryQuotation.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.literary_quotations << o
         #render_component :controller => "literary_quotations", :action => "public_edit", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'literary_quotation', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
         redirect_to edit_dynamic_literary_quotation_url(o.id) 
       end
       if params["relatedtype"] == "full_synonyms_to"
         o = FullSynonym.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.full_synonyms_tos << o
         render_component :controller => "full_synonyms", :action => "public_edit", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'full_synonyms_to', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
       end
       if params["relatedtype"] == "translation_equivalent"
         o = TranslationEquivalent.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.translation_equivalents << o
         #render_component :controller => "translation_equivalents", :action => "public_edit", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'translation_equivalent', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
         redirect_to edit_dynamic_translation_equivalent_url(o.id)
       end
       if params["relatedtype"] == "sub_definition"
         o = DefinitionDefinition.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.sub_definitions << o
         render_component :controller => "definition_definitions", :action => "edit_dynamic", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'sub_definition', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
       end
       if params["relatedtype"] == "etymology"
         o = Etymology.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.etymologies << o
         #render_component :controller => "etymologies", :action => "public_edit", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'etymology', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
         redirect_to edit_dynamic_etymology_url(o.id)
       end
       if params["relatedtype"] == "related_definition"
         o = Definition.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.related_definitions << o
         render_component :controller => "definitions", :action => "public_edit", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'related_definition', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
       end
       if params["relatedtype"] == "oral_quotation"
         o = OralQuotation.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.oral_quotations << o
         #render_component :controller => "oral_quotations", :action => "public_edit", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'oral_quotation', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
         redirect_to edit_dynamic_oral_quotation_url(o.id)
       end
       if params["relatedtype"] == "meta"
         o = Meta.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.meta = o
         @definition.save
         #render_component :controller => "metas", :action => "edit_dynamic", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'meta', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
         #redirect_to meta_metadata_edit_dynamic_meta_url(o.id)
         redirect_to edit_dynamic_meta_url(o.id)
       end
       if params["relatedtype"] == "spelling"
         o = Spelling.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.spellings << o
         #render_component :controller => "spellings", :action => "public_edit", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'spelling', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
         redirect_to edit_dynamic_spelling_url(o.id)
       end
       if params["relatedtype"] == "model_sentence"
         o = ModelSentence.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.model_sentences << o
         #render_component :controller => "model_sentences", :action => "public_edit", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'model_sentence', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
         redirect_to edit_dynamic_model_sentence_url(o.id)
       end
       if params["relatedtype"] == "definition_definition_form_to"
         o = DefinitionDefinitionForm.new
         o.relationship_to = params['role_to']
         o.relationship_from = params['role_from']
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.definition_definition_form_tos << o
         render_component :controller => "definition_definition_forms", :action => "edit_dynamic", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'definition_definition_form_to', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
       end
       if params["relatedtype"] == "translation"
         o = Translation.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.translations << o
         #render_component :controller => "translations", :action => "public_edit", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'translation', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
         redirect_to edit_dynamic_translation_url(o.id)
       end
       if params["relatedtype"] == "pronunciation"
         o = Pronunciation.new
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.pronunciations << o
         #render_component :controller => "pronunciations", :action => "public_edit", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'pronunciation', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
         redirect_to edit_dynamic_pronunciation_url(o.id)
       end
       if params["relatedtype"] == "definition_definition_form_from"
         o = DefinitionDefinitionForm.new
         o.relationship_to = params['role_to']
         o.relationship_from = params['role_from']
         o.created_by = session[:user].login
         o.created_at = Time.now
         o.update_history = session[:user].login + " ["+Time.now.to_s+"] \n"
         o.save
         @definition.definition_definition_form_froms << o
         #render_component :controller => "definition_definition_forms", :action => "edit_dynamic", :id => o.id, :params => {'internal' => internal, 'pk' => params['id'], 'relatedtype'=> 'definition_definition_form_from', 'level' => params['level'], 'new' => 'yes', 'definition_id' => params['definition_id']}
         # before hanving new related term with search box as first step
         #redirect_to edit_dynamic_definition_definition_forms_url(o.id, :internal => internal, :pk => params['id'], :relatedtype => 'definition_definition_form_from', :level => params['level'], :new => 'yes', :definition_id => params['definition_id'] )  
         redirect_to new_search_definition_definition_forms_url(o.id, :internal => internal, :pk => params['id'], :relatedtype => 'definition_to', :level => params['level'], :new => 'yes', :definition_id => params['definition_id'] )  

       end
   end
   
   def find_head_terms
       @current_tab_id = :search
       @current_section = :showview
       if session[:user] != nil
         @logged_in = true
       else
         @logged_in = false
       end

        if params['mode'] != nil 
           @page_class = params['mode']
        else
           @page_class = 'edit'
        end
        sort_init 'sort_order'
        sort_update
        if params['items_per_page'] != nil
           items_per_page = params['items_per_page'].to_i
        else
           items_per_page = 50
        end
        puts "---------ipg = #{params['items_per_page']}"
        vals=""
        query=""
        @array = []
        term_value = 'empty'
        @q = params['query']

        if params['query']
           @query = buildquery(params["query"])
           query = buildquery(params["query"])
           flash["query"] = params["query"]
           # if session['query'] != nil and params['paged'] != nil
           #   query = session['query']
           if session['search_type'] != nil
             session['search_type'] = 'term'
           end
        else
           if params['term'] != nil and params['term'] != ''
              val = params['term']
              # key = 'term'
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
              puts '-------extent = '
              puts params
              if params['search_extent'] == nil
                 query += ' and ' if query != nil
                 query = query + "level = ?"
                 @array.push("head term")
                 vals += ',' if vals != ''
                 vals += 'level:head term'
              end


              vals += ',' if vals != ''
              vals = vals + key + ":" + val

           end
           # end
           # end
           query = [query]+@array

           # end
           session['query'] = query
        end
        puts 'query----------------------------'
        puts query

        if query == [""] and (params['sub_definitions'] == nil or params['sub_definitions'] == "") and (params['full_synonyms'] == nil or params['full_synonyms'] == "") and (params['oral_quotations'] == nil or params['oral_quotations'] == "") and (params['etymologies'] == nil or params['etymologies'] == "") and (params['literary_quotations'] == nil or params['literary_quotations'] == "") and (params['model_sentences'] == nil or params['model_sentences'] == "") and (params['related_definitions'] == nil or params['related_definitions'] == "") and (params['meta'] == nil or params['meta'] == "") and (params['translations'] == nil or params['translations'] == "") and (params['super_definitions'] == nil or params['super_definitions'] == "") and (params['definition_definition_form_froms'] == nil or params['definition_definition_form_froms'] == "") and (params['definition_definition_form_tos'] == nil or params['definition_definition_form_tos'] == "") and (params['spellings'] == nil or params['spellings'] == "") and (params['full_synonyms_froms'] == nil or params['full_synonyms_froms'] == "") and (params['pronunciations'] == nil or params['pronunciations'] == "") and (params['translation_equivalents'] == nil or params['translation_equivalents'] == "")

           if params['items_per_page'] != nil
              items_per_page = params['items_per_page'].to_i
           else
              items_per_page = 50
           end
           sort_clause = "sort_order asc"
           @definition_pages = Paginator.new self, Definition.count(:conditions => "level = 'head term'"), items_per_page, params['page']
           #@definitions = Definition.find :all, :order => sort_clause, :conditions => "level = 'head term'", :limit => @definition_pages.items_per_page, :offset => @definition_pages.current.offset
           @definitions = Definition.where("level = 'head term'").order(sort_clause).limit(@definition_pages.items_per_page).offset(@definition_pages.current.offset) 
           if @definition_pages.item_count != 0
              @pages = (@definition_pages.item_count.to_f / items_per_page.to_f).ceil
              @current_page = (@definition_pages.current.first_item.to_f / @definition_pages.item_count.to_f * @pages).ceil
           else
              @pages = 0
              @current_page = 0
           end
           # @page_class = 'search'
           flash['query'] = '' #query
           puts "-------------------list #{@definitions.size }"
           render  :layout => 'staging_new'#'staging'
        else

           if vals == ""
              vals = params["query"]
           end
           #  ---------  build custom paginator to handle extra queries -----------------
           if params['items_per_page'] != nil
              items_per_page = params['items_per_page'].to_i
           else
              items_per_page = 50
           end
           @q = query

           @definition_pages = Paginator.new self, Definition.count(:conditions => query), items_per_page, params['page']
           @definitions = Definition.find :all, :order => sort_clause, :conditions => query, :limit => @definition_pages.items_per_page, :offset => @definition_pages.current.offset
           if @definition_pages.item_count != 0
              @pages = (@definition_pages.item_count.to_f / items_per_page.to_f).ceil
              @current_page = (@definition_pages.current.first_item.to_f / @definition_pages.item_count.to_f * @pages).ceil
           else
              @pages = 0
              @current_page = 0
           end

           # -----------------------------------------------------------------------------
           flash["query"] = vals
           flash["existingquery"] = params["query"]

           puts items_per_page
           puts @definitions.length
           # if @definitions.length == 0
           #    # 
           #    # val = term_value
           #    # space = Unicode::U0F0B
           #    # line = Unicode::U0F0D
           #    # val = val.gsub(line,'')
           #    # val = val.gsub(space,'_space_')
           #    # a = val.split('_space_')
           #    # word = ''
           #    # a.each {|w|
           #    #    word += space if word != ''
           #    #    word += w
           #    # }
           #    # val = word
           #    # 
           #    # if params['search_type'] == 'exact'
           #    #    @dan_martin_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Dan Martin Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"')")
           #    #    @ives_waldo_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Ives Waldo Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"')")
           #    #    @jeffrey_hopkins_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jeffrey Hopkins Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"')")
           #    #    @jim_valby_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jim Valby Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"')")
           #    #    @richard_baron_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Richard Baron Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"')")
           #    #    @rangjung_yeshe_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Rangujung Yeshe Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"')")
           #    #    @yogacara_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Yogācāra Glossary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"')")
           #    #    @tshig_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'bod rgya tshig mdzod chen mo' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"')")
           #    # elsif params['search_type'] == 'anywhere'
           #    #    @dan_martin_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Dan Martin Dictionary' and (term ilike '%"+val+"%')")
           #    #    @ives_waldo_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Ives Waldo Dictionary' and (term ilike '%"+val+"%')")
           #    #    @jeffrey_hopkins_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jeffrey Hopkins Dictionary' and (term ilike '%"+val+"%')")
           #    #    @jim_valby_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jim Valby Dictionary' and (term ilike '%"+val+"%')")
           #    #    @richard_baron_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Richard Baron Dictionary' and (term ilike '%"+val+"%')")
           #    #    @rangjung_yeshe_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Rangujung Yeshe Dictionary' and (term ilike '%"+val+"%')")
           #    #    @yogacara_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Yogācāra Glossary' and (term ilike '%"+val+"%')")
           #    #    @tshig_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'bod rgya tshig mdzod chen mo' and (term ilike '%"+val+"%')")
           #    # else
           #    #    @dan_martin_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Dan Martin Dictionary' and (term ilike '"+val+"%')")
           #    #    @ives_waldo_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Ives Waldo Dictionary' and (term ilike '"+val+"%')")
           #    #    @jeffrey_hopkins_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jeffrey Hopkins Dictionary' and (term ilike '"+val+"%')")
           #    #    @jim_valby_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jim Valby Dictionary' and (term ilike '"+val+"%')")
           #    #    @richard_baron_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Richard Baron Dictionary' and (term ilike '"+val+"%')")
           #    #    @rangjung_yeshe_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Rangujung Yeshe Dictionary' and (term ilike '"+val+"%')")
           #    #    @yogacara_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Yogācāra Glossary' and (term ilike '"+val+"%')")
           #    #    @tshig_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'bod rgya tshig mdzod chen mo' and (term ilike '"+val+"%')")
           #    # end
           #    # # @dan_martin_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Dan Martin Dictionary' and term = '"+term_value+"'")
           #    # # @ives_waldo_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Ives Waldo Dictionary' and term = '"+term_value+"'")
           #    # # @jeffrey_hopkins_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jeffrey Hopkins Dictionary' and term = '"+term_value+"'")
           #    # # @jim_valby_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jim Valby Dictionary' and term = '"+term_value+"'")
           #    # # @richard_baron_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Richard Baron Dictionary' and term = '"+term_value+"'")
           #    # # @rangjung_yeshe_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Rangjung Yeshe Dictionary' and term = '"+term_value+"'")
           #    # # @yogacara_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Yogācāra Glossary' and term = '"+term_value+"'")
           #    # # @tshig_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'bod rgya tshig mdzod chen mo' and term = '"+term_value+"'")
           #    @term_value = term_value
           #    render :template => 'definitions/no_matches',:layout => 'staging'
           # else
              # render_action 'list'
              @term_value = term_value
              render :layout => 'staging_new'#'staging'
           # end
        end

     end


     def public_show_list
       @definition = Definition.find(params[:id])
       @dan_martin_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Dan Martin Dictionary' and term = '"+@definition.term+"'")
       @ives_waldo_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Ives Waldo Dictionary' and term = '"+@definition.term+"'")
       @jeffrey_hopkins_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jeffrey Hopkins Dictionary' and term = '"+@definition.term+"'")
       @jim_valby_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jim Valby Dictionary' and term = '"+@definition.term+"'")
       @richard_baron_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Richard Baron Dictionary' and term = '"+@definition.term+"'")
       @rangjung_yeshe_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Rangjung Yeshe Dictionary' and term = '"+@definition.term+"'")
       @yogacara_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Yogācāra Glossary' and term = '"+@definition.term+"'")
       @tshig_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'bod rgya tshig mdzod chen mo' and term = '"+@definition.term+"'")
       render :layout => false
       # render :text => 'done'
       # render :template => '/definitions/edit_show'
     end

     def public_term
       @current_tab_id = :term
       $CURRENT_TERM = params[:id]
       if params['mode'] == 'search'
         @page_class = 'search'
       elsif params['mode'] == 'edit'
         @page_class = 'edit'
       else
         @page_class = 'browse'
       end

       @tibetan_space = Unicode::U0F0B
       @tibetan_space_fix = Unicode::U0F0B + Unicode::U200B

       #logged_in?
       if session[:user] != nil
         @logged_in = true
       else
         @logged_in = false
       end

       puts '--------'
       puts 'head ?'+params[:id].to_s
       @non_head_id = 0
       @definition = Definition.find(params[:id])
       if @definition.level != 'head term'
         id = @definition.find_head_term
         if id != nil
           puts id
           @non_head_id = params[:id]
           @definition = Definition.find(id)
         end
       end

       @definition.term = '' if @definition.term == nil

       val = @definition.term
        space = Unicode::U0F0B
        space2 = Unicode::U0F0C
        line = Unicode::U0F0D
        nb_space = Unicode::U00A0

        # val = val.gsub("#{nb_space}",' ')  #remove non-breaking space before tsheg

        val = val.strip

        val = val.gsub(line,'')
        val = val.gsub(space2,space)
         val = val.gsub(space,'_space_')
         a = val.split('_space_')
         word = ''
         a.each {|w| 
           word += space if word != ''
           word += w 
         }

         val = word.gsub("'","''")


       #@dan_martin_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Dan Martin Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       @dan_martin_definitions = OldDefinition.where("dictionary = 'Dan Martin Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       #@ives_waldo_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Ives Waldo Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       @ives_waldo_definitions = OldDefinition.where("dictionary = 'Ives Waldo Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       #@jeffrey_hopkins_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jeffrey Hopkins Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       @jeffrey_hopkins_definitions = OldDefinition.where("dictionary = 'Jeffrey Hopkins Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       #@jim_valby_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Jim Valby Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       @jim_valby_definitions = OldDefinition.where("dictionary = 'Jim Valby Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       #@richard_baron_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Richard Baron Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       @richard_baron_definitions = OldDefinition.where("dictionary = 'Richard Baron Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       #@rangjung_yeshe_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Rangujung Yeshe Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       @rangjung_yeshe_definitions = OldDefinition.where("dictionary = 'Rangujung Yeshe Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       #@yogacara_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Yogācāra Glossary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       @yogacara_definitions = OldDefinition.where("dictionary = 'Yogācāra Glossary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       #@tshig_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'bod rgya tshig mdzod chen mo' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
       @tshig_definitions = OldDefinition.where("dictionary = 'bod rgya tshig mdzod chen mo' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")

       
       if params['list_view'] == "true"
         #debugger
         if !params['ui_dialog'].blank? #in a thickbox, so a temporary solution or hack
           #this is to UI info
           #debugger
           respond_to do |format|
             format.js { render :layout=>false }
           end
           #render :layout => 'staging_popup_show'
         else #not in a thickbox
           #this is for browse expand info
           
           #commented for browse testing
           #render :layout => false #render :layout => 'staging_popup_show' #render :layout => false   #without the layout no jquery calls available
         end    
       else
         @current_section = :showview
         #render :layout => 'staging_new'
         #application layout is loading as default
       end
     end


     def index_edit
       @current_section = :home
       @users = Dictionary::User.find :all, :conditions => 'full_name is not null'
       @page_class = 'edit'
       render :layout => 'staging_new' 
     end

       def public_edit
         @current_tab_id = :term
         @grammatical_function_type = Category.find(286)
         @page_class = "edit"
         @tibetan_space = Unicode::U0F0B
         @tibetan_space_fix = Unicode::U0F0B + Unicode::U200B
         # initialize_variables

         @level = '[["",""],["head term","head term"],["not head","not head"]]'

         @non_head_id = 0
         @definition = Definition.find(params[:id])
         if @definition.level != 'head term'
           id = @definition.find_head_term
           if id != nil
             @non_head_id = params[:id]
             @definition = Definition.find(id)
           end
         end
         #@definition.updated_by = session[:user].login

         @head_id = @definition.id

         @definition.term = 'Click to modify new term' if @definition.term == nil or @definition.term == ''
         @definition.definition = 'Click to modify definition'  if @definition.definition == nil or @definition.definition == ''

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
         @richard_baron_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Richard Baron Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
         @rangjung_yeshe_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Rangujung Yeshe Dictionary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
         @yogacara_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'Yogācāra Glossary' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")
         @tshig_definitions = OldDefinition.find(:all, :conditions => "dictionary = 'bod rgya tshig mdzod chen mo' and (term = '"+val+"' or term = '"+val+space+"' or term = '"+val+line+"' or term = '"+val+space+line+"' or term = '"+val+space2+"' or term = '"+val+space2+line+"')")

         #render :layout => 'staging_new' 
         #render :layout => 'basic' 
         #application layout is loading as default
       end



  #Creation of Definition or Sub-definition
  def public_add
    head = Definition.find(params[:id]) #'parent_id'])
    definition = Definition.new
    definition.term = head.term
    definition.level = 'not head'
    definition.save
    dd = DefinitionDefinition.new
    dd.def1_id = params[:id]
    dd.def2_id = definition.id
    dd.save
    redirect_to :controller => 'definitions', :action => 'edit_dynamic_definition', :id => definition.id, :params => {'internal' => 'edit_box','public'=>'yes','definition_id'=> params['parent_id']} 
    #removing redirection and incorporating public addition to its own segment, and re-using editorial partials
    
    #redirect_to edit_dynamic_definition_definition_url(definition.id, :internal => 'edit_box', :public => 'yes', :definition_id => params['parent_id'])
  end

       #Restful update to take care of best_in_place calls
       def update
           @definition = Definition.find(params[:id])
           @definition.update_attributes(params[:definition])
           respond_with @definition
       end

       def update_dynamic_definition
         @definition = Definition.find(params[:id])
         if @definition.created_by == nil or @definition.created_by == ""
           @definition.created_by = session[:user].login
           @definition.created_at = Time.now
         end
         if session[:user] != nil
           @definition.updated_by = session[:user].login
         end
         @definition.updated_at = Time.now
         if @definition.update_history == nil
           #@definition.update_history = session[:user].login + " ["+Time.now.to_s+"]"
         else
         	#@definition.update_history += session[:user].login + " ["+Time.now.to_s+"]"
         end   
         
           if @definition.update_attributes(params[:definition])
          
           end
        
       end

       def edit_dynamic_definition
         
         @data = Category.find(184)
         @level = ["","head term","not head"]
         @alphabet = ComplexScripts::TibetanLetter.all
         #@language = []
         #Language.find(:all, :order => 'language asc').each do |l|
          # @language += [l.language]
         #end
         #@tense = "imperative, past, present, future".split(', ')
         #@register = []
         #Register.find(:all).each do |l|
          # @register += [l.register]
         #end
         #@language_context = []
         #LanguageContext.find(:all).each do |l|
          # @language_context += [l.language_context]
         #end
         #@literary_genre = []
         #LiteraryGenre.find(:all).each do |l|
          # @literary_genre += [l.literary_genre]
         #end
         #@literary_period = []
         #LiteraryPeriod.find(:all).each do |l|
          # @literary_period += [l.literary_period]
         #end
         #@literary_form = []
         #LiteraryForm.find(:all).each do |l|
          # @literary_form += [l.literary_form]
         #end

         #@theme_ones = ThemeLevelOne.find(:all)
         #@theme_array = ""
         #@internal_theme_array = ""
         #for md in @theme_ones
         #  @theme_array += ",\n" unless @theme_array == ""
         #  md.theme = '-' if md.theme == nil
         #  @theme_array += "['"+md.theme+"', \"javascript:set_field('"+md.theme+"','definition[thematic_classification]','"+url_for(:action => 'set_thematic_classification',:id => params[:id].to_s)+"');\",null"
         #  @internal_theme_array += ",\n" unless @internal_theme_array == ""
         #  @internal_theme_array += "['"+md.theme+"', \"javascript:set_field('"+md.theme+"','internal_definition[thematic_classification]','"+url_for(:action => 'set_thematic_classification',:id => params[:id].to_s)+"');\",null"
         #  if md.theme_level_twos.size > 0
         #    @theme_array += ",\n"
         #    @internal_theme_array += ",\n"
         #  else
         #    @theme_array += ",null,\n"
         #    @internal_theme_array += ",null,\n"
         #  end
         #  theme_two_array = ""
         #  internal_theme_two_array = ""
         #  for sd in md.theme_level_twos
         #    theme_two_array += ",\n" unless theme_two_array == ""
         #    sd.theme = '-' if sd.theme == nil
         #    theme_two_array += "  ['"+sd.theme+"', \"javascript:set_field('"+md.theme+" > "+sd.theme+"','definition[thematic_classification]','"+url_for(:action => 'set_thematic_classification',:id => params[:id].to_s)+"');\",null"
         #    internal_theme_two_array += ",\n" unless internal_theme_two_array == ""
         #    internal_theme_two_array += "  ['"+sd.theme+"', \"javascript:set_field('"+md.theme+" > "+sd.theme+"','internal_definition[thematic_classification]','"+url_for(:action => 'set_thematic_classification',:id => params[:id].to_s)+"');\",null"
         #    if sd.theme_level_threes.size > 0
         #      theme_two_array += ",\n"
         #      internal_theme_two_array += ",\n"
         #    else
         #      theme_two_array += ",null,\n"
         #      internal_theme_two_array += ",null,\n"
         #    end
         #    theme_three_array = ""
         #    internal_theme_three_array = ""
         #    for td in sd.theme_level_threes
         #      theme_three_array += ",\n" unless theme_three_array == ""
         #      td.theme = '-' if td.theme == nil
         #      theme_three_array += "    ['"+td.theme+"', \"javascript:set_field('"+md.theme+" > "+sd.theme+" > "+td.theme+"','definition[thematic_classification]','"+url_for(:action => 'set_thematic_classification',:id => params[:id].to_s)+"');\"]\n"
         #      internal_theme_three_array += ",\n" unless internal_theme_three_array == ""
         #      internal_theme_three_array += "    ['"+td.theme+"', \"javascript:set_field('"+md.theme+" > "+sd.theme+" > "+td.theme+"','internal_definition[thematic_classification]','"+url_for(:action => 'set_thematic_classification',:id => params[:id].to_s)+"');\"]\n"
         #    end
         #    theme_two_array += theme_three_array+"\n]"
         #    internal_theme_two_array += internal_theme_three_array+"\n]"
         #  end
         #  @theme_array += theme_two_array+"\n]"
         #  @internal_theme_array += internal_theme_two_array+"\n]"
         #end
         #@theme_array = "[\n['Choose Theme',null,null,\n"+@theme_array+"],['Cancel',null,null]	]"
         #@internal_theme_array = "[\n['Choose Theme',null,null,\n"+@internal_theme_array+"],['Cancel',null,null]	]"

         #@grammar_function_level_ones = GrammarFunctionLevelOne.find(:all)
         #@grammar_function_array = ""
         #@internal_grammar_function_array = ""
         #for md in @grammar_function_level_ones
         #  @grammar_function_array += ",\n" unless @grammar_function_array == ""
         #  md.grammar_function = "-" if md.grammar_function == nil
         #  @grammar_function_array += "['"+md.grammar_function.to_s+"', \"javascript:set_field('"+md.grammar_function.to_s+"','definition[grammatical_function]','"+url_for(:action => 'set_grammatical_function',:id => params[:id].to_s)+"');\",null" #unless md.grammar_function != nil
         #  @internal_grammar_function_array += ",\n" unless @internal_grammar_function_array == ""
         #  @internal_grammar_function_array += "['"+md.grammar_function+"', \"javascript:set_field('"+md.grammar_function+"','internal_definition[grammatical_function]','"+url_for(:action => 'set_grammatical_function',:id => params[:id].to_s)+"');\",null"
         #  if md.grammar_function_level_twos.size > 0
         #    @grammar_function_array += ",\n"
         #    @internal_grammar_function_array += ",\n"
         #  else
         #    @grammar_function_array += ",null,\n"
         #    @internal_grammar_function_array += ",null,\n"
         #  end
         #  grammar_function_two_array = ""
         #  internal_grammar_function_two_array = ""
         #  for sd in md.grammar_function_level_twos
         #    grammar_function_two_array += ",\n" unless grammar_function_two_array == ""
         #    sd.grammar_function = "-" if sd.grammar_function == nil
         #    grammar_function_two_array += "  ['"+sd.grammar_function+"', \"javascript:set_field('"+md.grammar_function+" > "+sd.grammar_function+"','definition[grammatical_function]','"+url_for(:action => 'set_grammatical_function',:id => params[:id].to_s)+"');\",null" unless sd.grammar_function == nil or md.grammar_function == nil
         #    internal_grammar_function_two_array += ",\n" unless internal_grammar_function_two_array == ""
         #    internal_grammar_function_two_array += "  ['"+sd.grammar_function+"', \"javascript:set_field('"+md.grammar_function+" > "+sd.grammar_function+"','internal_definition[grammatical_function]','"+url_for(:action => 'set_grammatical_function',:id => params[:id].to_s)+"');\",null" unless sd.grammar_function == nil or md.grammar_function == nil
         #    if sd.grammar_function_level_threes.size > 0
         #      grammar_function_two_array += ",\n"
         #      internal_grammar_function_two_array += ",\n"
         #    else
         #      grammar_function_two_array += ",null,\n"
         #      internal_grammar_function_two_array += ",null,\n"
         #    end
         #    grammar_function_three_array = ""
         #    internal_grammar_function_three_array = ""
         #    for td in sd.grammar_function_level_threes
         #      grammar_function_three_array += ",\n" unless grammar_function_three_array == ""
         #      td.grammar_function = "-" if td.grammar_function == nil
         #      grammar_function_three_array += "    ['"+td.grammar_function+"', \"javascript:set_field('"+md.grammar_function+" > "+sd.grammar_function+" > "+td.grammar_function+"','definition[grammatical_function]','"+url_for(:action => 'set_grammatical_function',:id => params[:id].to_s)+"');\"]\n"
         #      internal_grammar_function_three_array += ",\n" unless internal_grammar_function_three_array == ""
         #      internal_grammar_function_three_array += "    ['"+td.grammar_function+"', \"javascript:set_field('"+md.grammar_function+" > "+sd.grammar_function+" > "+td.grammar_function+"','internal_definition[grammatical_function]','"+url_for(:action => 'set_grammatical_function',:id => params[:id].to_s)+"');\"]\n"
         #    end
         #    grammar_function_two_array += grammar_function_three_array+"\n]"
         #    internal_grammar_function_two_array += internal_grammar_function_three_array+"\n]"
         #  end
         #  @grammar_function_array += grammar_function_two_array+"\n]"
         #  @internal_grammar_function_array += internal_grammar_function_two_array+"\n]"
         #end
         #@grammar_function_array = "[\n['Choose Grammatical Function',null,null,\n"+@grammar_function_array+"],['Cancel',null,null]	]"
         #@internal_grammar_function_array = "[\n['Choose Grammatical Function',null,null,\n"+@internal_grammar_function_array+"],['Cancel',null,null]	]"

         #@major_dialects = MajorDialect.find(:all)
         #@dialect_array = ""
         #@internal_dialect_array = ""
         #for md in @major_dialects
         #  @dialect_array += ",\n" unless @dialect_array == ""
         #  md.name = '-' if md.name == nil
         #  @dialect_array += "['"+md.name+"', \"javascript:set_field('"+md.name+"','definition[major_dialect_family]','"+url_for(:action => 'set_major_dialect_family',:id => params[:id].to_s)+"');\",null"
         #  @internal_dialect_array += ",\n" unless @internal_dialect_array == ""
         #  @internal_dialect_array += "['"+md.name+"', \"javascript:set_field('"+md.name+"','internal_definition[major_dialect_family]','"+url_for(:action => 'set_major_dialect_family',:id => params[:id].to_s)+"');\",null"
         #  if md.specific_dialects.size > 0
         #    @dialect_array += ",\n"
         #    @internal_dialect_array += ",\n"
         #  else
         #    @dialect_array += ",null,\n"
         #    @internal_dialect_array += ",null,\n"
         #  end
         #  specific_dialect_array = ""
         #  internal_specific_dialect_array = ""
         #  for sd in md.specific_dialects
         #    specific_dialect_array += ",\n" unless specific_dialect_array == ""
         #    sd.name = '-' if sd.name == nil
         #    specific_dialect_array += "  ['"+sd.name+"', \"javascript:set_field('"+md.name+" > "+sd.name+"','definition[major_dialect_family]','"+url_for(:action => 'set_major_dialect_family',:id => params[:id].to_s)+"');\"]\n"
         #    internal_specific_dialect_array += ",\n" unless internal_specific_dialect_array == ""
         #    internal_specific_dialect_array += "  ['"+sd.name+"', \"javascript:set_field('"+md.name+" > "+sd.name+"','internal_definition[major_dialect_family]','"+url_for(:action => 'set_major_dialect_family',:id => params[:id].to_s)+"');\"]\n"
         #  end
         #  @dialect_array += specific_dialect_array+"\n]"
         #  @internal_dialect_array += internal_specific_dialect_array+"\n]"
         #end
         #@dialect_array = "[\n['Choose Dialect',null,null,\n"+@dialect_array+"],['Cancel',null,null]	]"
         #@internal_dialect_array = "[\n['Choose Dialect',null,null,\n"+@internal_dialect_array+"],['Cancel',null,null]	]"


         if(params['internal'] != nil)
           @divname = 'definition_internal'
         else
         	@divname = 'definition'
         end
         if params['level'] != nil
           params['level'] = (params['level'].to_i + 1).to_s
         else
           params['level'] = '1'
         end
         @definition = Definition.find(params[:id])
         print "-----------------"+@definition.sub_definitions.size.to_s
         print "\nno layout\n" if params['internal'] != nil or params['public'] != nil
         ##render :layout => false if params['internal'] != nil or params['public'] != nil
         ##render :layout => 'staging_new'
         #render :layout => 'staging_popup'  


         #render :layout => false  #due to ui
         respond_to do |format|
             format.js { render :layout=>false }
         end
       end


       def definition_show
         @definition = Definition.find(params[:id])
       end

       def definition_edit
         @definition = Definition.find(params[:id])
         respond_to do |format|
             format.js { render :layout=>false }
         end
       end
       
       def definition_update
         @definition = Definition.find(params[:definition][:id])
         #if @definition.created_by == nil or @definition.created_by == ""
        #   @definition.created_by = session[:user].login
        #   @definition.created_at = Time.now
        # end
         #if session[:user] != nil
        #   @definition.updated_by = session[:user].login
        # end
         #@definition.updated_at = Time.now
         #if @definition.update_history == nil
         #  @definition.update_history = session[:user].login + " ["+Time.now.to_s+"]"
         #else
         #	@definition.update_history += session[:user].login + " ["+Time.now.to_s+"]"
         #end   
          if @definition.update_attributes(params[:definition])
             respond_to do |format|
                  format.js { render :layout=>false }
              end
          end
       end
       
       def inline_show
         @definition = Definition.find(params[:id])
          respond_to do |format|
            format.js { render :layout=>false }
          end
       end

       def inline_edit
           @definition = Definition.find(params[:id])
           respond_to do |format|
                format.js { render :layout=>false }
            end
       end

       def inline_update
           @definition = Definition.find(params[:definition][:id])
           if @definition.created_by == nil or @definition.created_by == ""
             @definition.created_by = session[:user].login
             @definition.created_at = Time.now
           end
           if session[:user] != nil
             @definition.updated_by = session[:user].login
           end
           @definition.updated_at = Time.now
           #if @definition.update_history == nil
           #  @definition.update_history = session[:user].login + " ["+Time.now.to_s+"]"
           #else
           #	@definition.update_history += session[:user].login + " ["+Time.now.to_s+"]"
           #end   
          if @definition.update_attributes(params[:definition])
              respond_to do |format|
                  format.js { render :layout=>false }
              end
          end
       end
       
       
       def inline_dropdown_show
         @definition = Definition.find(params[:id])
          respond_to do |format|
            format.js { render :layout=>false }
          end
       end

       def inline_dropdown_edit
           @definition = Definition.find(params[:id])
           @level = ["","head term","not head"]
           @alphabet = ComplexScripts::TibetanLetter.all
           respond_to do |format|
                format.js { render :layout=>false }
            end
       end
       
       def inline_dropdown_update
            @definition = Definition.find(params[:definition][:id])
            if @definition.created_by == nil or @definition.created_by == ""
              @definition.created_by = session[:user].login
              @definition.created_at = Time.now
            end
            if session[:user] != nil
              @definition.updated_by = session[:user].login
            end
            @definition.updated_at = Time.now
            #if @definition.update_history == nil
            #  @definition.update_history = session[:user].login + " ["+Time.now.to_s+"]"
            #else
            #	@definition.update_history += session[:user].login + " ["+Time.now.to_s+"]"
            #end   
           if @definition.update_attributes(params[:definition])
               respond_to do |format|
                   format.js { render :layout=>false }
               end
           end
        end
        
       def display_history
     	  @history = params[:history]
     	  @history = ''
     	  hash = {}
     	  c = eval(params[:history_class])
     	  o = c.find params[:history_id]
     	  h = o.update_history #params[:history]
     	  a = h.split("\n")
        a.each {|k| hash[k.split(' ')[0]] = k} 
        hash.each do |k,v|
           k = 'none' if k == nil
           user = Dictionary::User.find(:first,:conditions=>"login='"+k+"'")

           @history += hash[k].gsub(k,user.full_name) unless user == nil
           @history += "\n"
        end
     	end
  

       
      def public_remove_etymology
        d = Definition.find(params[:id])
        p = Etymology.find(params['etymology'])
        @etymology = Etymology.find(params['etymology'])
        @temp_definition = Definition.find(params[:id])
        d.etymologies.delete(p) unless d == nil
      end
      
      def public_remove_translation_equivalent
        d = Definition.find(params[:id])
        p = TranslationEquivalent.find(params['translation_equivalent'])
        @translation_equivalent = TranslationEquivalent.find(params['translation_equivalent'])
        @temp_definition = Definition.find(params[:id])
        d.translation_equivalents.delete(p) unless d == nil
      end

      def public_remove_pronunciation
        d = Definition.find(params[:id])
        p = Pronunciation.find(params['pronunciation'])
        @pronunciation = Pronunciation.find(params['pronunciation'])
        @temp_definition = Definition.find(params[:id])        
        d.pronunciations.delete(p) unless d == nil
      end

      def public_remove_spelling
        d = Definition.find(params[:id])
        p = Spelling.find(params['spelling'])
        @spelling = Spelling.find(params['spelling'])
        @temp_definition = Definition.find(params[:id])
        d.spellings.delete(p) unless d == nil
      end
      
      def public_remove_translation
        #now determine who's the parent of the translation to update
        translation = Translation.find(params['translation'])
          if translation.definition_id.nil?
            if translation.etymology_id.nil?
              if translation.literary_quotation_id.nil?
                if translation.oral_quotation_id.nil?
                  if translation.model_sentence_id.nil?
                  else
                    @parent_element = ModelSentence.find(translation.model_sentence_id) 
                    @temp_definition = Definition.find(@parent_element.definitions.first.definition_id)
                  end
                else
                  @parent_element = OralQuotation.find(translation.oral_quotation_id) 
                  @temp_definition = Definition.find(@parent_element.definitions.first.definition_id)
                end
              else
                @parent_element = LiteraryQuotation.find(translation.literary_quotation_id) 
                @temp_definition = Definition.find(@parent_element.definitions.first.definition_id)
              end
            else
              @parent_element = Etymology.find(translation.etymology_id) 
              @temp_definition = Definition.find(@parent_element.definition_id)
            end
          else
            @parent_element = Definition.find(translation.definition_id) 
            @temp_definition = Definition.find(translation.definition_id) 
          end
        
        #d = Definition.find(params[:id])
        #p = Translation.find(params['translation'])
        #d.translations.delete(p) unless d == nil
        @parent_element.translations.delete(translation) unless @parent_element == nil
        
      end
      
      
      def public_remove_model_sentence
        d = Definition.find(params[:id])
        p = ModelSentence.find(params['model_sentence'])
        @model_sentence = ModelSentence.find(params['model_sentence'])
        @temp_definition = Definition.find(@model_sentence.definitions.first.id)         
        d.model_sentences.delete(p) unless d == nil
      end
      
    def public_remove_literary_quotation
      d = Definition.find(params[:id])
      p = LiteraryQuotation.find(params['literary_quotation'])
      @literary_quotation = LiteraryQuotation.find(params['literary_quotation'])
      @temp_definition = Definition.find(@literary_quotation.definitions.first.id)
      d.literary_quotations.delete(p) unless d == nil
    end  

    def public_remove_oral_quotation
      d = Definition.find(params[:id])
      p = OralQuotation.find(params['oral_quotation'])
      @oral_quotation = OralQuotation.find(params['oral_quotation'])
      @temp_definition = Definition.find(@oral_quotation.definitions.first.id)
      d.oral_quotations.delete(p) unless d == nil
    end      
      
    def public_remove_meta
      p = Meta.destroy(params['meta'])
      redirect_to :action => 'public_edit', :id => params['head_id']
    end

    def public_remove_source
      p = Source.destroy(params['source'])
      redirect_to :action => 'public_edit', :id => params['head_id']
    end      
  
    def public_remove_full_synonym
      d = Definition.find(params[:id])
      p = FullSynonym.find(params['full_synonym'])
      @temp_definition = Definition.find(params[:id])
      d.full_synonyms.delete(p) unless d == nil
    end
      
    def public_remove_form_from
      d = Definition.find(params[:id])
      p = DefinitionDefinitionForm.find(params['form_from'])
      @temp_definition = Definition.find(params[:id])
      d.definition_definition_form_froms.delete(p) unless d == nil
    end  
      
    #Actions to remove Translations from other modules, pending to upgrade

    
      
      
end