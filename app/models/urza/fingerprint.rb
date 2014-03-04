require 'phashion'

module Urza
  class Fingerprint < ActiveRecord::Base
    belongs_to :card

    def self.hamming_distances(new_fingerprint, cards)
      distances = Hash.new { |h,k| h[k] = [] }

      cards.each do |card|
        card.fingerprints.each do |old_fingerprint|
          distance = Phashion.hamming_distance(new_fingerprint.to_i, old_fingerprint.to_i)
          distances[distance] << card
        end
      end

      distances
    end

    def to_i
      phash.to_i
    end
  end
end
