require 'phashion'

module Urza
  class Fingerprint < ActiveRecord::Base
    belongs_to :card

    def self.hamming_distances(new_fingerprint)
      distances = Hash.new { |h,k| h[k] = [] }

      Fingerprint.all.each do |known_fingerprint|
        hamming = Phashion.hamming_distance(new_fingerprint.to_i, known_fingerprint.to_i)
        distances[hamming] << known_fingerprint.card_id
      end

      distances
    end

    def to_i
      phash.to_i
    end
  end
end
