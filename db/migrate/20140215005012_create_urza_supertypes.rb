class CreateUrzaSupertypes < ActiveRecord::Migration
  def change
    create_table :urza_supertypes do |t|
      t.string :name

      t.timestamps
    end
  end
end
