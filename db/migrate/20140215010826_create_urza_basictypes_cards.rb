class CreateUrzaBasictypesCards < ActiveRecord::Migration
  def change
    create_table :urza_basictypes_cards do |t|
      t.integer :card_id
      t.integer :basictype_id
    end
  end
end
