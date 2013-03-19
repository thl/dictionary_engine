class FullSynonym < ActiveRecord::Base
  has_one :meta, :foreign_key => 'full_synonym_id'
  has_and_belongs_to_many :definitions, :join_table => 'definition_full_synonyms', :association_foreign_key => 'definition_id', :foreign_key => 'full_synonym_id'

end

# == Schema Info
# Schema version: 20100924060552
#
# Table name: full_synonyms
#
#  id             :integer         not null, primary key
#  created_by     :string(80)
#  term           :string(80)
#  update_history :text
#  updated_by     :string(80)
#  created_at     :string(80)
#  updated_at     :string(80)