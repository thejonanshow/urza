module Urza
  class Expansion < ActiveRecord::Base
    has_many :cards
  end
end
