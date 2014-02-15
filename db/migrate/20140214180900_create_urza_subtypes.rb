class CreateUrzaSubtypes < ActiveRecord::Migration
  def change
    create_table :urza_subtypes do |t|
      t.string :name

      t.timestamps
    end
  end
end
