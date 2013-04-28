class AddColumnsToStartups < ActiveRecord::Migration
  def change
    add_column :startups, :startup_name, :string
    add_column :startups, :target_market, :string
    add_column :startups, :description, :text
  end
end
