# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: 'Userone', email: 'locknrolls.user1@gmail.com', subscription_status: true, phone: 1111111, password: 11111111)
Lock.create(lock_name: 'Front Door', user_id: 1)
