class CreateUserRolePowerdnsRecords < ActiveRecord::Migration
  def change
    create_table :user_role_powerdns_records do |t|
      t.integer :user_id
      t.integer :role_id
      t.integer :record_id

      t.timestamps
    end

    add_index :user_role_powerdns_records, [ :user_id, :role_id, :record_id ], unique: true, name: 'userrecord_index'
  end
end
