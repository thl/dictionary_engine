module ApplicationHelper
  
  def stylesheet_files
    #super + ['jquery.autocomplete', 'jquery.checktree','thickbox', 'modalbox', 'menu', 'http://www.thlib.org/global/css/thdl_style.css', 'http://www.thlib.org//reference/dictionaries/tibetan-dictionary/css/tibetan-dictionary.css', 'thdl_public']
    super + ['jquery.autocomplete', 'jquery.checktree','thickbox', 'modalbox', 'menu', 'http://www.thlib.org/global/css/thdl_style.css', 'thdl_public', 'jquery-ui-tabs', 'jquery-ui']
  end

  def javascript_files
    if @current_section == :home
      super 
    else 
      if @current_section == :showview
        #super + ['thickbox-compressed']
        ['jquery', 'jquery-ui', 'best_in_place'] + super + ['thickbox-compressed']
      else
        ## aug_23 ['jquery','jquery-ui'] + super +  ['jquery.inplace.pack','jquery.autocomplete', 'jquery.checktree', 'model-searcher','thickbox-compressed', 'modalbox','menu', 'menu_items', 'menu_tpl', 'jquery-ui-tabs']
        ###super +  ['jquery.inplace.pack','jquery.autocomplete', 'jquery.checktree', 'model-searcher','thickbox-compressed', 'modalbox','menu', 'menu_items', 'menu_tpl']
        #['jquery', 'jquery-ui', 'best_in_place'] + super +  ['jquery.inplace','jquery.autocomplete', 'jquery.checktree', 'model-searcher','thickbox-compressed','menu', 'menu_items', 'menu_tpl']
        #comments above 9 dic 2012
        #super + ['best_in_place'] 
        #['jquery', 'jquery-ui'] + super +  ['jquery.inplace','jquery.autocomplete', 'jquery.checktree', 'model-searcher','thickbox-compressed','menu', 'menu_items', 'menu_tpl']
        #['jquery', 'jquery-ui'] + super + ['thickbox-compressed', 'best_in_place']
        super +  ['best_in_place', 'category_selector', 'jquery.inplace','jquery.autocomplete', 'jquery.checktree', 'model-searcher','thickbox-compressed','menu', 'menu_items', 'menu_tpl']
      end
    end
    #['jquery','jquery-ui'] + super
  end
  
  def javascripts
    if @current_section == :home
      super 
    else 
      if @current_section == :showview
        super
      else #edit mode then needs tiny_mce
        #[super, include_tiny_mce_if_needed].join("\n").html_safe
        super
      end
    end
  end
  
  def tmb_url
    hostname = Socket.gethostname.downcase
    if hostname =~ /sds[3-578].itc.virginia.edu/
      tmb = 'http://tmb.thlib.org'
    elsif hostname == 'sds6.itc.virginia.edu'
      tmb = 'http://staging.tmb.thlib.org'
    elsif hostname == 'dev.thlib.org'
      tmb = 'http://dev.tmb.thlib.org'
    else
      tmb = 'http://tmb.thlib.org'
    end
    return tmb.html_safe
  end
  
  def app_host_url
    hostname = Socket.gethostname.downcase
    if hostname =~ /sds[3-578].itc.virginia.edu/
      app_host = 'http://thlib.org'
    elsif hostname == 'sds6.itc.virginia.edu'
      app_host = 'http://staging.thlib.org'
    elsif hostname == 'dev.thlib.org'
      app_host = 'http://dev.thlib.org'
    else
      app_host = 'http://thlib.org'
    end
    return app_host.html_safe
  end
  
  def thl_catalog_host_url
    hostname = Socket.gethostname.downcase
    if hostname =~ /sds[3-578].itc.virginia.edu/
      app_host = 'http://thlib.org'
    elsif hostname == 'sds6.itc.virginia.edu'
      app_host = 'http://staging.thlib.org'
    elsif hostname == 'dev.thlib.org'
      app_host = 'http://dev.thlib.org'
    else
      app_host = 'http://thlib.org'
    end
    return app_host
  end
  
  def current_term_path
      if $CURRENT_TERM.nil?
        term_path = root_path
      else
        term_path = public_term_definition_path($CURRENT_TERM)
      end
      return term_path
    end
  
  def custom_secondary_tabs_list
       # The :index values are necessary for this hash's elements to be sorted properly
       if $CURRENT_TERM.nil?
         {
         ##:custom_home => {:index => 1, :title => "Home", :url => "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/&div_id=universal_navigation_content" },
         ##:custom_home => {:index => 1, :title => "Home", :url => custom_home_path + "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/&div_id=universal_navigation_content" },
         #:custom_home => {:index => 1, :title => "Home", :url => root_path + "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/&div_id=universal_navigation_content" },
         :custom_home => {:index => 1, :title => "Home", :url => root_path },

         #:search => {:index => 2, :title => "Search", :url => root_path },
         :search => {:index => 2, :title => "Search", :url => search_main_definition_path },
         #:term => {:index => 3, :title => "Term", :url => current_term_path },
         :browse => {:index => 4, :title => "Browse", :url => browse_definitions_path },
         :translate => {:index => 5, :title => "Translate", :url => "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/translate.php&div_id=universal_navigation_content"},
         :hierarchies => {:index => 6, :title => "Hierarchies", :url => "#{tmb_url}"},
         :projects => {:index => 7, :title => "Projects", :url => "#{tmb_url}/categories/236/children"},
         #:bibliography => {:index => 7, :title => "Bibliography", :url => "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/dictionary-biblio.php#spt=SPT--BrowseResources.php?ParentId=1476&div_id=universal_navigation_content"},
         :bibliography => {:index => 7, :title => "Bibliography", :url => "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/dictionary-biblio.php&div_id=universal_navigation_content"},
         }
       else
         {
         ##:custom_home => {:index => 1, :title => "Home", :url => "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/&div_id=universal_navigation_content" },
         ##:custom_home => {:index => 1, :title => "Home", :url => custom_home_path + "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/&div_id=universal_navigation_content" },
         #:custom_home => {:index => 1, :title => "Home", :url => root_path + "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/&div_id=universal_navigation_content" },
         :custom_home => {:index => 1, :title => "Home", :url => root_path },

         #:search => {:index => 2, :title => "Search", :url => root_path },
         :search => {:index => 2, :title => "Search", :url => search_main_definition_path },
         :term => {:index => 3, :title => "Term", :url => current_term_path },
         :browse => {:index => 4, :title => "Browse", :url => browse_definitions_path },
         :translate => {:index => 5, :title => "Translate", :url => "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/translate.php&div_id=universal_navigation_content"},
         :hierarchies => {:index => 6, :title => "Hierarchies", :url => "#{tmb_url}"},
         :projects => {:index => 7, :title => "Projects", :url => "#{tmb_url}/categories/236/children"},
         #:bibliography => {:index => 7, :title => "Bibliography", :url => "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/dictionary-biblio.php#spt=SPT--BrowseResources.php?ParentId=1476&div_id=universal_navigation_content"},
         :bibliography => {:index => 7, :title => "Bibliography", :url => "#iframe=#{app_host_url}/reference/dictionaries/tibetan-dictionary/dictionary-biblio.php&div_id=universal_navigation_content"},
         }       
       end      
     end
     
  def custom_secondary_tabs(current_tab_id=:term)
    @tab_options ||= {}
    @tab_options[:urls] ||= {}

    tabs = custom_secondary_tabs_list

    current_tab_id = :search unless tabs.keys.include? current_tab_id

    @tab_options[:urls].each do |tab_id, url|
      tabs[tab_id][:url] = url unless tabs[tab_id].nil? || url.nil?
    end


    tabs = tabs.sort{|a,b| a[1][:index] <=> b[1][:index]}.collect{|tab_id, tab| 
      [tab_id, tab[:title], tab[:url]]
    }

    tabs
  end
  
  def side_column_links
    host_url = app_host_url
    str = "	<h4 id=\"side-home-link\"><a href=\"#{host_url}/reference/dictionaries/tibetan-dictionary/\" title=\"Tibetan Dictionary Home\">Tibetan Dictionary Home</a></h4>"
    str += "<h3 class=\"head\">#{link_to 'Tibetan Dictionary Project', '#nogo', {:hreflang => 'Description for Tibetan Dictionary Project.'}}</h3>\n<ul>\n"
		str += "<li><a href=\"#{host_url}/reference/dictionaries/tibetan-dictionary/about/wiki/thdl%20tibetan%20historical%20dictionary%20overview.html\" title=\"\">Project Overview</a></li>"
		str += "<li><a href=\"#{host_url}/reference/dictionaries/tibetan-dictionary/about/wiki/thdl%20tibetan%20historical%20dictionary%20introduction.html\" title=\"\">Historical Dictionary Intro</a></li>"
		str += "<li><a href=\"#{host_url}/reference/dictionaries/tibetan-dictionary/translate.php\" title=\"\">Tibetan Translation</a></li>"
		str += "<li><a href=\"#{host_url}/reference/dictionaries/tibetan-dictionary/about/wiki/thdl%20tibetan%20historical%20dictionary%20status%20report.html\" title=\"\">Status</a></li>"
		str += "<li><a href=\"#{host_url}/reference/dictionaries/tibetan-dictionary/about/wiki/thdl tibetan historical dictionary help.html\" title=\"\">Dictionaries Help</a></li>"
	  
	  #if !session[:user].nil?
	    str += "<li class=\"loggedon\">#{link_to 'Edit', index_edit_definitions_path, {:hreflang => 'Dictionary Edit.'}}</li>\n"   
	    str += "<li class=\"loggedon\">#{link_to 'New', new_main_definition_path, {:hreflang => 'Dictionary New.'}}</li>\n" 
    #end
    str += "<li><a href=\"#{host_url}/reference/dictionaries/tibetan-dictionary/sitewiki/c06fa8cf-c49c-4ebc-007f-482de5382105/tibetan historical dictionary editorial manual.html\">Editorial Manual</a></li>"
		str += "<li><a href=\"#{host_url}/reference/dictionaries/tibetan-dictionary/about/wiki/thdl%20tibetan%20historical%20dictionary%20about%20us.html\" title=\"\">About Us</a></li>"
		str += "<li><a href=\"#{host_url}/reference/dictionaries/tibetan-dictionary/about/wiki/thdl%20tibetan%20historical%20dictionary%20how%20to%20participate.html\" title=\"\">How to Participate</a></li>"
		str += "<li><a href=\"#{host_url}/reference/dictionaries/tibetan-dictionary/about/wiki/thdl%20tibetan%20historical%20dictionary%20sponsors.html\" title=\"\">Sponsors</a></li>"
		str += "<li><a href=\"#{host_url}/reference/dictionaries/tibetan-dictionary/about/wiki/thdl%20tibetan%20historical%20dictionary%20how%20to%20cite.html\" title=\"\">How to Cite</a></li>"
		str += "<li><a href=\"javascript:linkTo_UnCryptMailto('nbjmup;uimAdpmmbc/jud/wjshjojb/fev');\">Contact Us</a></li>"
    str += "</ul>"
    
		str += "<h3 class=\"head global-links\"><a href=\"#nogo\" title=\"\">Reference</a></h3>"
    str += "\n<ul>\n"
    str += "<li><a href=\"#{host_url}/reference/\" title=\"Link to Reference Home Page\">Reference Home</a></li>"
  	str += "<li><a href=\"#{host_url}/reference/bibliographies/\" title=\"\">Bibliographies</a></li>"
  	str += "<li><a href=\"#{host_url}/reference/dictionaries/\" title=\"\">Dictionaries</a></li>"
  	str += "<li><a href=\"#{host_url}/reference/search-places/\" title=\"\">Search for Places</a></li>"
  	str += "<li><a href=\"#{host_url}/reference/tibetan-grammar/\" title=\"\">Tibetan Grammars</a></li>"
  	str += "<li><a href=\"#{host_url}/reference/tibetan-translation/\" title=\"\">Tibetan Translation</a></li>"
  	str += "<li><a href=\"#{host_url}/reference/timelines/\" title=\"\">Timelines</a></li>"
  	str += "<li>#{link_to 'Topical Map Builder', tmb_url}</li>"
  	str += "<li><a href=\"#{host_url}/reference/transliteration/\" title=\"\">Transliteration</a></li>"
    str += "</ul>"
    
    return str.html_safe     
  end
  
  def login_status
    if session[:user].blank?
      return "#{link_to 'Login', login_account_path}."
    else
      return "Logged in as #{session[:user].login}. #{link_to 'Logout', logout_account_path}."
    end

  end
  
  #definition editorial methods
  def text_show_action(edit_action)
    case edit_action
    when "term_edit"
      "term_show"
    when "term_popupedit"
      "term_popupshow"
    when "wylie_edit"
      "wylie_show"
    when "phonetic_edit"
      "phonetic_show"
    end
  end
  
  def text_update_action(edit_action)
    case edit_action
    when "term_edit"
      "update_term"
    when "term_popupedit"
      "update_popupterm"
    when "wylie_edit"
      "update_wylie"
    when "phonetic_edit"
      "update_phonetic"
    end
  end
  
  def text_edit_url(controller, update_action, id)
    case update_action
    when "update_term", "term_show"
      case controller
        when "definitions"
          definition_term_edit_url(:id => id)
      end
    when "update_popupterm", "term_popupshow"
      case controller
        when "definitions"
          definition_term_popupedit_url(:id => id)
      end
    when "update_wylie", "wylie_show"
      case controller
        when "definitions"
          definition_wylie_edit_url(:id => id)
      end
    when "update_phonetic", "phonetic_show"
      case controller
        when "definitions"
          definition_phonetic_edit_url(:id => id)
      end
    end
  end
  
   def dynamic_text_field(edit_action)
     case edit_action
     when "term_edit"
       "term"
     when "term_popupedit"
       "term"  
     when "wylie_edit"
       "wylie"
     when "phonetic_edit"
       "phonetic"
     end
  end
  
  
end
