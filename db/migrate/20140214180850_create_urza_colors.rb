class CreateUrzaColors < ActiveRecord::Migration
  def change
    create_table :urza_colors do |t|
      t.string :name

      t.timestamps
    end
  end
end
