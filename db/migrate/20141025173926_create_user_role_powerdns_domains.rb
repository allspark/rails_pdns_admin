class CreateUserRolePowerdnsDomains < ActiveRecord::Migration
  def change
    create_table :user_role_powerdns_domains do |t|
      t.integer :user_id
      t.integer :role_id
      t.integer :domain_id

      t.timestamps
    end

    add_index :user_role_powerdns_domains, [ :user_id, :role_id, :domain_id ], unique: true, name: 'userroledomain_idx'
  end
end
