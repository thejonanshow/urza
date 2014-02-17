module Urza
  class Card < ActiveRecord::Base
    belongs_to :expansion
    has_many :names, :class_name => 'CardName'
    has_and_belongs_to_many :colors
    has_and_belongs_to_many :supertypes
    has_and_belongs_to_many :basictypes
    has_and_belongs_to_many :subtypes
    has_many :card_variations
    has_many :variations, :through => :card_variations

    def image_path
      File.join(Rails.root, 'tmp', 'images', "#{multiverse_id}.jpg")
    end
  end
end
