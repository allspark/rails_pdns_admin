# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

guest = Role.create(name: 'guest', shortname: :guest)
global_admin_role = Role.create(name: 'Sys-Admin', shortname: :sysadmin)
domain_owner_role = Role.create(name: 'Domain-Owner', shortname: :domainown)
record_owner_role = Role.create(name: 'Record-Owner', shortname: :recordown)
record_updater_role = Role.create(name: 'Record-Updater', shortname: :recordupd)


admin_user = User.create(email: 'allspark@wormhole.eu', password: '1234567890', confirmed_at: Time.now)

admin_user_role = UserRole.create(user: admin_user, role: global_admin_role)
