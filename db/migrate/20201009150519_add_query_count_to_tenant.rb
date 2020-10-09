class AddQueryCountToTenant < ActiveRecord::Migration
  def change
    add_column :tenants, :query_count, :integer, default: 0
  end
end
