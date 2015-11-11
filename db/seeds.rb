# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

# Goal.destroy_all
# Adviser.destroy_all
# User.destroy_all

coach_user = User.new(
  email: "remi@mail.com",
  password: "12345678"
)
coach_user.save
coach_adviser = Adviser.new(
  title: "Docteur nutritionniste",
  user_id: coach_user.id
)
coach_adviser.save

patient_user = User.new(
  email: "test@mail.com",
  password: "12345678",
  adviser_id: coach_adviser.id
)
patient_user.save

measure_type = MeasureType.new(
    name: "poids",
    unit: "kg",
    data_type: "test"
  )
measure_type.save

measure = Measure.new(
      value: 50,
      date: Time.now,
      user_id: 1,
      source: "Withings",
      measure_type_id: measure_type.id
    )
measure.save
