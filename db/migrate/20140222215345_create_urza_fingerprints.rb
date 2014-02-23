class CreateUrzaFingerprints < ActiveRecord::Migration
  def change
    create_table :urza_fingerprints do |t|
      t.integer :card_id
      t.string :phash

      t.timestamps
    end
  end
end
