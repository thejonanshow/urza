class CreateUrzaCardNames < ActiveRecord::Migration
  def change
    create_table :urza_card_names do |t|
      t.string :name
      t.integer :card_id

      t.timestamps
    end
  end
end
