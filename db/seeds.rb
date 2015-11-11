# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# require 'faker'

coach_user = User.new(
  email: "remi@mail.com",
  password: "ousousous",
  first_name: "Remi",
  birthday: Time.new(1985, 10, 20),
  sexe: "male"
)
coach_user.save

coach_adviser = Adviser.new(
  title: "Docteur nutritionniste",
  user_id: coach_user.id
)
coach_adviser.save
<<<<<<< HEAD
​
patient_user = User.new(
  email: "ous@mail.com",
  password: "ousousous",
  adviser_id: coach_adviser.id,
  first_name: "Ousmane",
  birthday: Time.new(1990, 05, 12),
  sexe: "male"
)
patient_user.save

measure_type = MeasureType.new(
  name: "poids",
  unit: "kg",
  data_type: "test"
)
measure_type.save
​
measure = Measure.new(
  value: 50,
  date: Time.new(2015, 11, 9),
  user_id: 2,
  source: "Withings",
  measure_type_id: measure_type.id
)
measure.save
