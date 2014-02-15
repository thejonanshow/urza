class CreateUrzaCards < ActiveRecord::Migration
  def change
    create_table :urza_cards do |t|
      t.string :layout
      t.string :full_name
      t.string :mana_cost
      t.float :cmc
      t.string :card_type
      t.string :rarity
      t.text :text
      t.text :flavor_text
      t.string :artist
      t.string :number
      t.string :power
      t.string :toughness
      t.integer :loyalty
      t.integer :multiverse_id
      t.string :image_name
      t.string :watermark
      t.string :border
      t.integer :hand
      t.integer :life

      t.timestamps
    end
  end
end
