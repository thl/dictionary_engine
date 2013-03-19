Rails.application.routes.draw do
  resources :categories do
    member do
      get :contract
      get :expand
    end
    resources :children do
      member do
        get :contract
        get :expand
      end
    end
  end
  
  resource :account do
    collection do
      post :login
      get :login
      get :logout
      get :welcome
    end
  end
  
  
  resources :definitions do
    member do
      match 'new_inplace/branches/:branch_id' => 'definition_category_associations#new_inline', :as => :new_inplace_category_definition_association

    end
    collection do
      get :index_edit
      post :find_head_terms
    end
  end
 
  
  #========== Translations Routes
  resources :translations do
    member do
      get :edit_dynamic
      get :update_dynamic
      get :inline_edit
      get :inline_show
      post :inline_update
    end
  end
  
  #match 'translations/:id/edit_dynamic_translation' => 'translations#edit_dynamic_translation', :as => :edit_dynamic_translation
  #match 'translations/:id/inline_edit' => 'translations#inline_edit', :as => :translation_inline_edit
  #match 'translations/:id/inline_show' => 'translations#inline_show', :as => :translation_inline_show
  
  
  #========== Spellings Routes
  resources :spellings 
 
  match 'spellings/:id/edit_dynamic_spelling' => 'spellings#edit_dynamic_spelling', :as => :edit_dynamic_spelling
  match 'spellings/:id/inline_edit' => 'spellings#inline_edit', :as => :spelling_inline_edit
  match 'spellings/:id/inline_show' => 'spellings#inline_show', :as => :spelling_inline_show
  
  
  #========== etymologies Routes
  resources :etymologies
  match 'etymologies/:id/edit_dynamic_etymology' => 'etymologies#edit_dynamic_etymology', :as => :edit_dynamic_etymology
  match 'etymologies/:id/inline_edit' => 'etymologies#inline_edit', :as => :etymology_inline_edit
  match 'etymologies/:id/inline_show' => 'etymologies#inline_show', :as => :etymology_inline_show
  
  match 'etymologies/:id/etymology_edit/:field' => 'etymologies#etymology_edit', :as => :etymology_edit
  match 'etymologies/:id/etymology_show' => 'etymologies#etymology_show', :as => :etymology_show
  #match 'etymologies/:id/etymology_popupedit' => 'etymologies#etymology_popupedit', :as => :etymology_popupedit
  #match 'etymologies/:id/etymology_popupshow' => 'etymologies#etymology_popupshow', :as => :etymology_popupshow
  #match 'etymologies/:id/analytical_note_edit' => 'etymologies#analytical_note_edit', :as => :etymology_analytical_note_edit
  #match 'etymologies/:id/analytical_note_show' => 'etymologies#analytical_note_show', :as => :etymology_analytical_note_show
  #match 'etymologies/:id/image_description_edit' => 'etymologies#image_description_edit', :as => :etymology_image_description_edit
  #match 'etymologies/:id/image_description_show' => 'etymologies#image_description_show', :as => :etymology_image_description_show
  #match 'etymologies/:id/audio_description_edit' => 'etymologies#audio_description_edit', :as => :etymology_audio_description_edit
  #match 'etymologies/:id/audio_description_show' => 'etymologies#audio_description_show', :as => :etymology_audio_description_show
  #match 'etymologies/:id/video_description_edit' => 'etymologies#video_description_edit', :as => :etymology_video_description_edit
  #match 'etymologies/:id/video_description_show' => 'etymologies#video_description_show', :as => :etymology_video_description_show
  match 'etymologies/:id/loan_language_edit' => 'etymologies#loan_language_edit', :as => :etymology_loan_language_edit
  match 'etymologies/:id/loan_language_show' => 'etymologies#loan_language_show', :as => :etymology_loan_language_show
  match 'etymologies/:id/loan_language_update' => 'etymologies#loan_language_update', :as => :etymology_loan_language_update
  
  
  #========== pronunciation Routes
  resources :pronunciations
  match 'pronunciations/:id/inline_edit' => 'pronunciations#inline_edit', :as => :pronunciation_inline_edit
  match 'pronunciations/:id/inline_show' => 'pronunciations#inline_show', :as => :pronunciation_inline_show

  match 'pronunciations/:id/pronunciation_edit' => 'pronunciations#pronunciation_edit', :as => :pronunciation_pronunciation_edit
  match 'pronunciations/:id/analytical_note_edit' => 'pronunciations#analytical_note_edit', :as => :pronunciation_analytical_note_edit
  match 'pronunciations/:id/image_description_edit' => 'pronunciations#image_description_edit', :as => :pronunciation_image_description_edit
  match 'pronunciations/:id/audio_description_edit' => 'pronunciations#audio_description_edit', :as => :pronunciation_audio_description_edit
  match 'pronunciations/:id/video_description_edit' => 'pronunciations#video_description_edit', :as => :pronunciation_video_description_edit
  #=========
  
  #==========  definition Routes
  match 'definitions/:id/term_edit' => 'definitions#term_edit', :as => :definition_term_edit
  match 'definitions/:id/term_show' => 'definitions#term_show', :as => :definition_term_show
  match 'definitions/:id/term_popupedit' => 'definitions#term_popupedit', :as => :definition_term_popupedit
  match 'definitions/:id/term_popupshow' => 'definitions#term_popupshow', :as => :definition_term_popupshow
  match 'definitions/:id/wylie_edit' => 'definitions#wylie_edit', :as => :definition_wylie_edit
  match 'definitions/:id/wylie_show' => 'definitions#wylie_show', :as => :definition_wylie_show
  match 'definitions/:id/phonetic_edit' => 'definitions#phonetic_edit', :as => :definition_phonetic_edit
  match 'definitions/:id/phonetic_show' => 'definitions#phonetic_show', :as => :definition_phonetic_show
  match 'definitions/:id/definition_edit' => 'definitions#definition_edit', :as => :definition_edit
  match 'definitions/:id/definition_show' => 'definitions#definition_show', :as => :definition_show
  match 'definitions/:id/definition_popupedit' => 'definitions#definition_popupedit', :as => :definition_popupedit
  match 'definitions/:id/definition_popupshow' => 'definitions#definition_popupshow', :as => :definition_popupshow
  match 'definitions/:id/language_context_edit' => 'definitions#language_context_edit', :as => :language_context_edit
  match 'definitions/:id/language_context_show' => 'definitions#language_context_show', :as => :language_context_show
  match 'definitions/:id/language_context_update' => 'definitions#language_context_update', :as => :language_context_update
  match 'definitions/:id/language_edit' => 'definitions#language_edit', :as => :definition_language_edit
  match 'definitions/:id/language_show' => 'definitions#language_show', :as => :definition_language_show
  match 'definitions/:id/language_update' => 'definitions#language_update', :as => :definition_language_update
  match 'definition_definition_forms/:id/edit_search_definition_definition_forms' => 'definition_definition_forms#edit_search', :as => :edit_search_definition_definition_forms
  match 'definitions/:id/public_show_list' => 'definitions#public_show_list', :as => :definition_public_show_list
  match 'definitions/:id/thematic_classification_edit' => 'definitions#thematic_classification_edit', :as => :thematic_classification_edit
  match 'definitions/:id/thematic_classification_show' => 'definitions#thematic_classification_show', :as => :thematic_classification_show
  match 'definitions/:id/grammatical_function_edit' => 'definitions#grammatical_function_edit', :as => :grammatical_function_edit
  match 'definitions/:id/grammatical_function_show' => 'definitions#grammatical_function_show', :as => :grammatical_function_show
  match 'definitions/:id/register_edit' => 'definitions#register_edit', :as => :register_edit
  match 'definitions/:id/register_show' => 'definitions#register_show', :as => :register_show
  match 'definitions/:id/literary_genre_edit' => 'definitions#literary_genre_edit', :as => :literary_genre_edit
  match 'definitions/:id/literary_genre_show' => 'definitions#literary_genre_show', :as => :literary_genre_show
  match 'definitions/:id/literary_period_edit' => 'definitions#literary_period_edit', :as => :literary_period_edit
  match 'definitions/:id/literary_period_show' => 'definitions#literary_period_show', :as => :literary_period_show
  match 'definitions/:id/literary_form_edit' => 'definitions#literary_form_edit', :as => :literary_form_edit
  match 'definitions/:id/literary_form_show' => 'definitions#literary_form_show', :as => :literary_form_show
  match 'definitions/:id/analytical_note_edit' => 'definitions#analytical_note_edit', :as => :analytical_note_edit
  match 'definitions/:id/analytical_note_show' => 'definitions#analytical_note_show', :as => :analytical_note_show
  match 'definitions/:id/image_description_edit' => 'definitions#image_description_edit', :as => :image_description_edit
  match 'definitions/:id/image_description_show' => 'definitions#image_description_show', :as => :image_description_show
  match 'definitions/:id/audio_description_edit' => 'definitions#audio_description_edit', :as => :audio_description_edit
  match 'definitions/:id/audio_description_show' => 'definitions#audio_description_show', :as => :audio_description_show
  match 'definitions/:id/video_description_edit' => 'definitions#video_description_edit', :as => :video_description_edit
  match 'definitions/:id/video_description_show' => 'definitions#video_description_show', :as => :video_description_show

  
  #==========  End of definition Routes
  
  
  #map.new_inplace_category_definition_association 'definitions/:definition_id/new_inplace/branches/:branch_id', :controller => 'definition_category_associations', :action => 'new_inline'
  #match 'definitions/:definition_id/new_inplace/branches/:branch_id' => 'definition_category_associations#new_inline', :as => :new_inplace_category_definition_association

  #map.resources :category_definition_associations, :controller => 'definition_category_associations', :path_prefix => 'definitions/:definition_id/branches/:branch_id'  
  match :category_definition_associations, :controller => 'definition_category_associations', :path_prefix => 'definitions/:definition_id/branches/:branch_id'
   


  #definitions
  #match 'definitions/:definition_id/inline_edit/:field' => 'definitions#inline_edit', :as => 'definition_inline_edit'
  #match '/definition_inline_edit' => 'definitions#inline_edit', :as => :definition_inline_edit
  match 'definitions/:id/inline_dropdown_edit' => 'definitions#inline_dropdown_edit', :as => :definition_inline_dropdown_edit
  match 'definitions/:id/inline_dropdown_show' => 'definitions#inline_dropdown_show', :as => :definition_inline_dropdown_show
  match 'definitions/:id/inline_edit' => 'definitions#inline_edit', :as => :definition_inline_edit
  match 'definitions/:id/inline_show' => 'definitions#inline_show', :as => :definition_inline_show
  match 'definitions/:id/inline_update' => 'definitions#inline_update', :as => :definition_inline_update
  
  
  #  map.resources :category_etymology_associations, :controller => 'category_etymology_associations', :path_prefix => 'etymologies/:etymology_id/branches/:branch_id'
  
  #  map.resources :category_etymology_associations, :controller => 'category_etymology_associations', :path_prefix => 'etymologies/:etymology_id/branches/:branch_id'
  match 'definitions/:id/term_edit' => 'definitions#term_edit', :as => :definition_term_edit

  match 'definitions/:id/wylie_edit' => 'definitions#wylie_edit', :as => 'definition_wylie_edit'
  
  
  #match '/' => 'definitions#home'
  #match 'definitions/search' => 'definitions#index', :as => :search_main_definition
  match 'search_definitions' => 'definitions#index', :as => :search_main_definition

   match 'definitions/new' => 'definitions#new', :as => :new_main_definition
  match 'browse_definitions' => 'definitions#browse', :as => :browse_definitions
    
  match 'home' => 'definitions#custom_home', :as => :home
  match 'internal_definitions/:action/:id' => 'definitions#index'
  match 'internal_definitions/public_term/:id' => 'definitions#public_term', :as => :public_term_definition
  #match '' => 'definitions#index'
  root :to => 'definitions#home'
  match '/:controller(/:action(/:id))'
end  