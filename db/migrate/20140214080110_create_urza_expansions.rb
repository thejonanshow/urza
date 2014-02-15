class CreateUrzaExpansions < ActiveRecord::Migration
  def change
    create_table :urza_expansions do |t|
      t.string :name
      t.string :abbreviation
      t.date :release_date
      t.string :border
      t.string :set_type

      t.timestamps
    end
  end
end
