module DefinitionsHelper
  
  def build_definition_menu()
    # delete_url = 'kkkl' #
    # puts '---------------------'
    # delete_url = link_to(image_tag('trash.gif',:border=>0), {:action => 'public_destroy', :id => id, :params => {:parent_id => parent_id, :head_id => head_id}}, :confirm => "Are you sure you want to delete this entry?").gsub(/"/,'')
    str = "[
	['Edit Relationships', null, null,
	  ['Add Sub Definition',\"javascript:add_def_popup('definitions',definition_id,parent_id);\",null],		  
		['Add Related Term', null, null,
  		['full synonym', \"javascript:search_term('definitions','full_synonym',definition_id);\"],
		  ['partial synonym',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'partial synonym','partial synonym');\"],
		  ['antonym',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'antonym','antonym');\"],
		  ['literary correlate',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'literary correlate','colloquial correlate');\"],
		  ['colloquial correlate',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'colloquial correlate','literary correlate');\"],
		  ['dialectical correlate',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'dialectical correlate','dialectical correlate');\"],
		  ['paired term',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'paired term','paired term');\"],
		  ['register', null, null,
		    ['double honorific form',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'double honorific form','non-honorific form');\"],
		    ['high honorific form',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'high honorific form','non-honorific form');\"],
		    ['honorific form',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'honorific form','non-honorific form');\"],
		    ['humilific form',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'humilific form','non-honorific form');\"]
		  ],
		  ['conjugated form', null, null,
    	  ['past tense',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'past tense','present tense');\"],
    	  ['future tense',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'future form','present tense');\"],
    	  ['imperative tense',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'imperative form','present tense');\"]
	    ],
		  ['division',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'division','division of');\"],
		  ['division of',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'division of','division');\"],
		  ['containing compound',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'compound','part of compound');\"],
		  ['part of compound',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'part of compound','compound');\"],
		  ['abbreviation',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'abbreviation','non-abbreviated form');\"],
		  ['non-abbreviated form',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'non-abbreviated form','abbreviation');\"],
		  ['containing phrase',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'phrase','part of phrase');\"],
		  ['part of phrase',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'part of phrase','phrase');\"],
		  ['poetic correlate',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'poetical correlate','non-poetical correlate');\"],
		  ['non-poetic correlate',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'non-poetical correlate','poetical correlate');\"],
		  ['gloss',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'gloss','gloss term');\"],
		  ['glossed term',\"javascript:add_new_relationship('definitions','definition_definition_form_from',definition_id,'gloss term','gloss');\"],
		],
		['Add Pronunciation', \"javascript:add_new_content('definitions','pronunciation',definition_id);\"],
		['Translation', null, null,
		  ['Find Translation',\"javascript:search_popup('definitions','translation',definition_id);\"],
		  ['New Translation',\"javascript:add_new_content('definitions','translation',definition_id);\"]
		],
		['Add Etymology', \"javascript:add_new_content('definitions','etymology',definition_id);\"],
		['Add Spelling', \"javascript:add_new_content('definitions','spelling',definition_id);\"],
		['Literary Quotation', null, null,
		  ['Find Literary Quotation',\"javascript:search_popup('definitions','literary_quotation',definition_id);\"],
		  ['New Literary Quotation',\"javascript:add_new_content('definitions','literary_quotation',definition_id);\"]
		],
		['Oral Quotation', null, null,
		  ['Find Oral Quotation',\"javascript:search_popup('definitions','oral_quotation',definition_id);\"],
		  ['New Oral Quotation',\"javascript:add_new_content('definitions','oral_quotation',definition_id);\"]
		],
		['Add Translation Equivalent', \"javascript:add_new_content('definitions','translation_equivalent',definition_id);\"],
		['Model Sentence', null, null,
		  ['Find Model Sentence',\"javascript:search_popup('definitions','model_sentence',definition_id);\"],
		  ['New Model Sentence',\"javascript:add_new_content('definitions','model_sentence',definition_id);\"]
		],
	  ['Add Metadata',\"javascript:add_new_popup('definitions','meta',definition_id);\"]
	],
	['Cancel',null,null]
];".html_safe
  end

  def build_translation_menu()
    str = "[
	['Edit Relationships', null, null,
		  ['New Meta',\"javascript:add_new_popup('translations','meta',translation_id);\"]
	],
	['Cancel',null,null]
];".html_safe
  end
  
   def build_related_term_menu()
      str = "[
  	['Edit Relationships', null, null,
  	  ['New Meta',\"javascript:add_new_popup('definition_definition_forms','meta',definition_definition_form_id);\"]
  	],
  	['Cancel',null,null]
  ];".html_safe
    end


    def build_pronunciation_menu()
      str = "[
  	['Edit Relationships', null, null,
  	  ['New Meta',\"javascript:add_new_popup('pronunciations','meta',pronunciation_id);\"]
  	],
  	['Cancel',null,null]
  ];".html_safe
    end

    def build_spelling_menu()
      str = "[
  	['Edit Relationships', null, null,
  	  ['New Meta',\"javascript:add_new_popup('spellings','meta',spelling_id);\"]
  	],
  	['Cancel',null,null]
  ];".html_safe
    end

    def build_etymology_menu()
      str = "[
  	['Edit Relationships', null, null,
  		['Translation', null, null,
  		  ['Find Translation',\"javascript:search_popup('etymologies','translation',etymology_id);\"],
  		  ['New Translation',\"javascript:add_new_popup('etymologies','translation',etymology_id);\"]
  		],
  	  ['New Meta',\"javascript:add_new_popup('etymologies','meta',etymology_id);\"]
  	],
  	['Cancel',null,null]
  ];".html_safe
    end

    def build_translation_equiv_menu()
      str = "[
  	['Edit Relationships', null, null,
  	  ['New Meta',\"javascript:add_new_popup('translation_equivalents','meta',translation_equivalent_id);\"]
  	],
  	['Cancel',null,null]
  ];".html_safe
    end

    def build_model_sentence_menu()
      str = "[
  	['Edit Relationships', null, null,
  		['Translation', null, null,
  		  ['Find Translation',\"javascript:search_popup('model_sentences','translation',model_sentence_id);\"],
  		  ['New Translation',\"javascript:add_new_popup('model_sentences','translation',model_sentence_id);\"]
  		],
  		  ['New Meta',\"javascript:add_new_popup('model_sentences','meta',model_sentence_id);\"]
  	],
  	['Cancel',null,null]
  ];".html_safe
    end

    def build_oral_quotation_menu()
      str = "[
  	['Edit Relationships', null, null,
  		['Translation', null, null,
  		  ['Find Translation',\"javascript:search_popup('oral_quotations','translation',oral_quotation_id);\"],
  		  ['New Translation',\"javascript:add_new_popup('oral_quotations','translation',oral_quotation_id);\"]
  		],
  		  ['New Meta',\"javascript:add_new_popup('oral_quotations','meta',oral_quotation_id);\"]
  	],
  	['Cancel',null,null]
  ];".html_safe
    end

    def build_literary_quotation_menu()
      str = "[
  	['Edit Relationships', null, null,
  		['Translation', null, null,
  		  ['Find Translation',\"javascript:search_popup('literary_quotations','translation',literary_quotation_id);\"],
  		  ['New Translation',\"javascript:add_new_popup('literary_quotations','translation',literary_quotation_id);\"]
  		],
  		  ['New Meta',\"javascript:add_new_popup('literary_quotations','meta',literary_quotation_id);\"]
  	],
  	['Cancel',null,null]
  ];".html_safe
    end

    def build_synonym_menu()
      str = "[
  	['Edit Relationships', null, null,
  		  ['New Meta',\"javascript:add_new_popup('full_synonyms','meta',full_synonym_id);\"]
  	],
  	['Cancel',null,null]
  ];".html_safe
    end
    
    def build_meta_menu()
      str = "[
  	['Edit Relationships', null, null,
  		  ['New Source',\"javascript:add_new_content('metas','source',meta_id);\"]
  	],
  	['Cancel',null,null]
  ];".html_safe
    end
    
end