class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.integer :shortname, default: 0
      t.text :description

      t.timestamps
    end

    add_index :roles, :shortname, unique: true
  end
end
