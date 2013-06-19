require_dependency "login_system"
require_dependency 'unicode'
require 'hpricot'
require 'open-uri'
require 'net/http'
require 'rexml/document'

class ApplicationController < ActionController::Base
  #protect_from_forgery
  uses_tiny_mce :options => { 
  								:theme => 'advanced',
  								:editor_selector => 'mceEditor2',
  								:width => '550px',
  								:height => '220px',
  								:strict_loading_mode => 'true',
  								:theme_advanced_resizing => 'true',
  								:theme_advanced_toolbar_location => 'top', 
  								:theme_advanced_toolbar_align => 'left',
  								:theme_advanced_buttons1 => %w{fullscreen separator bold italic underline strikethrough separator undo redo separator link unlink template formatselect code},
  								:theme_advanced_buttons2 => %w{cut copy paste separator pastetext pasteword separator bullist numlist outdent indent separator  justifyleft justifycenter justifyright justifiyfull separator removeformat  charmap },
  								:theme_advanced_buttons3 => [],
  								:plugins => %w{contextmenu paste media fullscreen template noneditable  },				
  								:template_external_list_url => '/templates/templates.js',
  								:noneditable_leave_contenteditable => 'true',
  								:theme_advanced_blockformats => 'p,h1,h2,h3,h4,h5,h6'
  								}
  								
  rescue_from ActionController::InvalidAuthenticityToken, :with => :bad_token

  helper :all # include all helpers, all the time
  
  protect_from_forgery :secret => '91f4ae4c2d9b8bb58461c68ee2ee27c7'
  
  include LoginSystem
  before_filter :login_required, :only => [:new, :edit, :destroy, :create, :list, :show, :show_edit, :edit_dynamic, :public_edit, :index_edit ]
	#before_filter :set_charset
  
  #def set_charset
  #  headers["Content-Type"] = "text/html; charset=utf-8" 
  #end
end
