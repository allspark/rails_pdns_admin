# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

global_admin_role = Role.create(name: 'Sys-Admin');
domain_owner_role = Role.create(name: 'Domain-Owner');
record_owner_role = Role.create(name: 'Record-Owner');
record_updater_role = Role.create(name: 'Record-Updater');


admin_user = User.create(email: 'allspark@wormhole.eu', password: '1234567890', confirmed_at: Time.now)
