class CreateUrzaCardsSupertypes < ActiveRecord::Migration
  def change
    create_table :urza_cards_supertypes do |t|
      t.integer :card_id
      t.integer :supertype_id
    end
  end
end
