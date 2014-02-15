class CreateUrzaCardsSubtypes < ActiveRecord::Migration
  def change
    create_table :urza_cards_subtypes do |t|
      t.integer :card_id
      t.integer :subtype_id
    end
  end
end
