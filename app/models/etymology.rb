class Etymology < ActiveRecord::Base
  has_one :meta, :foreign_key => 'etymology_id'
  has_many :translations, :foreign_key => 'etymology_id'
  belongs_to :definition, :foreign_key => 'definition_id'

  #for all kmaps associations 
  has_many :category_etymology_associations, :dependent => :destroy

  belongs_to :etymology_category, :class_name => 'Category'
  belongs_to :derivation_type, :class_name => 'Category'
  belongs_to :loan_language_type, :class_name => 'Category'
  belongs_to :literary_genre_type, :class_name => 'Category'
  belongs_to :literary_period_type, :class_name => 'Category'
  belongs_to :literary_form_type, :class_name => 'Category'
  belongs_to :major_dialect_family_type, :class_name => 'Category'

  def displayInfo
    str = ""
    str += etymology unless etymology == nil
    return str
  end
  
  #$etymology_type = "historical (linguistic), basic (syllabic), creative".split(', ')
  #$derivation = "primary, derivate".split(", ")
  #$major_dialect_family = "Standard Tibetan, Ütsang, Kham/Hor, Amdo, Tewo and Choni, Dzongkha-Sikkimese, Sherpa-Jirel, Lahul-Spiti, Ladakhi/Balti, Kyirong-Kagate, THDL Normalized Spelling, Alternative literary spelling, Mistaken spelling, Mistakenly corrected spelling, Old spelling, Vernacular Tibetan spelling, Standard Tibetan spelling, Unspecified".split(', ')
  #$specific_dialect = "Unspecified, Local Spelling - Unknown Locale, Central dialect, Lhasa dialect, Lhokha dialect, Kongpo dialect, Tsang dialect, Tö dialect, Central Kham dialect, Southern Kham dialect, Northeastern Kham dialect, Hor dialect, North Kokonor Amdo dialect, West Kokonor Amdo dialect, Southeast Kokonor Amdo dialect, South Gansu dialect, Golok Amdo dialect, Ngapa Amdo dialect, Tewo dialect, Choni dialect, Dzongkha, Khyöcha Ngachakha, Lakha, Merak Sakteng nomad dialect, Dur nomad dialect, Sikkimese, Sherpa dialect, Jirel dialect, Lahul/Garshwa dialect, Spiti dialect, Nyam dialect, Balti dialect, Ladakhi, Purik dialect, Kyirong dialect, Kagate dialect, Tsum dialect, Langtang dialect, Yolmo (Helambu Sherpa) dialect, other".split(', ')
  #$literary_genre = "".split(', ')
  #$literary_period = "old literary, classical literary, modern literary".split(', ')
  #$literary_form = "prose, verse, mixed prose/verse".split(', ')
  #$project = "Buddhist Tantra Terminology, TLLR Colloquial, Tournadre/Dorje Manual Glossary, TLLR Colloquial Standardized Spelling, TLLR Literary Glossary, THDL Architecture Terminology, THDL Astrology Terminology, THDL/Rubin Art Terminology, THDL Colophons, THDL Computer Science Terminology, THDL Library Science Terminology, THDL Medical Terminology, THDL Music Terminology, THDL Samantabhadra Titles, Public Domain Dictionary Entry Project".split(', ')
  #$source_type = "personal communication, text, original".split(", ")

end

# == Schema Info
# Schema version: 20100924060552
#
# Table name: etymologies
#
#  id                           :integer         not null, primary key
#  definition_id                :integer
#  derivation_type_id           :integer
#  etymology_category_id        :integer
#  literary_form_type_id        :integer
#  literary_genre_type_id       :integer
#  literary_period_type_id      :integer
#  loan_language_type_id        :integer
#  major_dialect_family_type_id :integer
#  analytical_note              :string(512)
#  audio                        :string(120)
#  audio_date                   :string(80)
#  audio_description            :text
#  audio_id_number              :string(120)
#  audio_link                   :string(256)
#  audio_place_of_recording     :string(120)
#  audio_speaker                :string(120)
#  created_by                   :string(80)
#  derivation                   :string(80)
#  etymology                    :text
#  etymology_type               :string(128)
#  image                        :string(256)
#  image_caption                :string(256)
#  image_description            :string(512)
#  image_link                   :string(256)
#  image_photographer           :string(128)
#  literary_form                :string(80)
#  literary_genre               :string(80)
#  literary_period              :string(80)
#  loan_language                :string(80)
#  major_dialect_family         :string(80)
#  specific_dialect             :string(80)
#  update_history               :text
#  updated_by                   :string(80)
#  video                        :string(120)
#  video_date                   :string(80)
#  video_description            :text
#  video_id_number              :string(120)
#  video_link                   :string(256)
#  video_place_of_recording     :string(120)
#  video_speaker                :string(120)
#  created_at                   :string(80)
#  updated_at                   :string(80)