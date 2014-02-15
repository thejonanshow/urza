module Urza
  class CardVariation < ActiveRecord::Base
    belongs_to :card
    belongs_to :variation, :class_name => 'Card'
  end
end
