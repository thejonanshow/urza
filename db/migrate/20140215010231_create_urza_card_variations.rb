class CreateUrzaCardVariations < ActiveRecord::Migration
  def change
    create_table :urza_card_variations do |t|
      t.integer :card_id
      t.integer :variation_id

      t.timestamps
    end
  end
end
