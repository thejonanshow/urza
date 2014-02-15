class CreateUrzaBasictypes < ActiveRecord::Migration
  def change
    create_table :urza_basictypes do |t|
      t.string :name

      t.timestamps
    end
  end
end
