class CreateUrzaCardsColors < ActiveRecord::Migration
  def change
    create_table :urza_cards_colors do |t|
      t.integer :card_id
      t.integer :color_id
    end
  end
end
