class Translation < ActiveRecord::Base
  has_one :meta, :foreign_key => 'translation_id'
  belongs_to :etymology, :foreign_key => 'etymology_id'
  belongs_to :definition, :foreign_key => 'definition_id'
  belongs_to :literary_quotation, :foreign_key => "literary_quotation_id"
  belongs_to :oral_quotation, :foreign_key => 'oral_quotation_id'
  belongs_to :model_sentence, :foreign_key => 'model_sentence_id'

  has_many :category_translation_associations, :dependent => :destroy
  belongs_to :language_type, :class_name => 'Category'

  def displayInfo
    str = ""
    str += translation unless translation == nil
    return str
  end

end

# == Schema Info
# Schema version: 20100924060552
#
# Table name: translations
#
#  id                    :integer         not null, primary key
#  definition_id         :integer
#  etymology_id          :integer
#  language_type_id      :integer
#  literary_quotation_id :integer
#  model_sentence_id     :integer
#  oral_quotation_id     :integer
#  analytical_note       :string(1024)
#  created_by            :string(80)
#  language              :string(80)
#  translation           :text
#  update_history        :text
#  updated_by            :string(80)
#  created_at            :string(80)
#  updated_at            :string(80)