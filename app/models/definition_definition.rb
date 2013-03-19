class DefinitionDefinition < ActiveRecord::Base
  belongs_to :sub_definition, :class_name => "Definition", :foreign_key => "def2_id"
  belongs_to :super_definition, :class_name => "Definition", :foreign_key => "def1_id"  
end

# == Schema Info
# Schema version: 20100924060552
#
# Table name: definition_definitions
#
#  id             :integer         not null, primary key
#  def1_id        :integer
#  def2_id        :integer
#  created_by     :string(80)
#  update_history :text
#  updated_by     :string(80)
#  created_at     :string(80)
#  updated_at     :string(80)