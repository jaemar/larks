class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation_count, :integer, default: 0
  end
end
