class AddExpansionIdToUrzaCard < ActiveRecord::Migration
  def change
    add_column :urza_cards, :expansion_id, :integer
  end
end
