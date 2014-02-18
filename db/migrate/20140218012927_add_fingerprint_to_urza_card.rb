class AddFingerprintToUrzaCard < ActiveRecord::Migration
  def change
    add_column :urza_cards, :fingerprint, :string
  end
end
