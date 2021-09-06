# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create({
    email: "q@q.q",
    password:"test", 
    password_confirmation:"test", 
    firstname:"newbie", 
    lastname:"junior"
})


Curr.create({
    cod:"BTC",
    desc:"Bitcoin",
    typ:"1"
})
Curr.create({
    cod:"USD",
    desc:"American Dollar",
    typ:"0"
})

Balance.create({
    curr: Curr.find(1),
    bal:"0.1",
    user:User.find(1),

})

Balance.create({
    curr:Curr.find(2),
    bal:1000,
    user:User.find(1),

})

