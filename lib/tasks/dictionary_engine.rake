namespace :dictionary_engine do
  export_brief = "Export dictionary head terms"
  desc export_brief
  task :export_head_terms => :environment do
    filename = ENV['FILENAME']
    if filename.blank?
      puts export_brief+
      "\nSyntax:\n"+
      "rake dictionary_engine:export_head_terms FILENAME=filename.csv"
    else
      require 'CSV'
      already_included_terms = []
      CSV.open(filename, 'w', "\t") do |writer|
        for definition in Definition.where(:level => 'head term').where('term IS NOT null').order('root_letter_id, sort_order, term')
          term = definition.term.mb_chars.strip
          next if already_included_terms.include? term
          already_included_terms << term
          writer << [definition.id, term, definition.root_letter.nil? ? '' : definition.root_letter.unicode]
        end
      end
    end
  end
  
  desc 'Generation of Static Pages'
  task :preheat_entries => :environment do |t|
     
    require File.join(File.dirname(__FILE__), '../static_pages.rb')
    
    StaticPages.build
  end
end
