# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

########################################
#   start_date added to Goal
########################################


1.times do
  coach_user = User.new(
    email: "remi@mail.com",
    password: "remremrem",
    first_name: "Remi",
    birthday: Time.new(1985, 10, 20),
    sexe: "male",
    is_adviser: true
  )
  coach_user.save

  coach_adviser = Adviser.new(
    title: "Docteur nutritionniste",
    user_id: coach_user.id
  )
  coach_adviser.save

  patient_user = User.new(
    email: "ous@mail.com",
    password: "ousousous",
    adviser_id: coach_adviser.id,
    first_name: "Ousmane",
    birthday: Time.new(1990, 05, 12),
    sexe: "male"
  )
  patient_user.save

  patient_user = User.new(
    email: "will@mail.com",
    password: "wilwilwil",
    adviser_id: coach_adviser.id,
    first_name: "William",
    birthday: Time.new(1985, 7, 16),
    sexe: "male"
  )
  patient_user.save

end

# measure_type: poids avec 2 measures et 1 goal

1.times do
  measure_type = MeasureType.new(
    name: "poids",
    unit: "kg",
    data_type: "test"
  )
  measure_type.save

  measure = Measure.new(
    value: 92,
    date: (Time.now) - 400000,
    user_id: 2,
    source: "Withings",
    measure_type_id: measure_type.id
  )
  measure.save

  goal = Goal.new(
    measure_type_id: 1,
    user_id: 2,
    adviser_id: 1,
    start_date: (Time.now) - 200000,
    end_value: 80,
    end_date: (Time.now) + 300000,
    title: "Maintenez votre poids à 80kg",
    cumulative: false
  )
  goal.save

  measure = Measure.new(
    value: 83,
    date: (Time.now),
    user_id: 2,
    source: "Withings",
    measure_type_id: measure_type.id
  )
  measure.save
end

# measure_type: tension avec 2 measures et 1 goal

1.times do
  measure_type = MeasureType.new(
    name: "tension",
    unit: "mmHg",
    data_type: "tensiontest"
  )
  measure_type.save

  measure = Measure.new(
    value: 155,
    date: (Time.now) - 400000,
    user_id: 2,
    source: "Withings",
    measure_type_id: measure_type.id
  )
  measure.save

  goal = Goal.new(
    measure_type_id: 2,
    user_id: 2,
    adviser_id: 1,
    start_date: (Time.now) - 200000,
    end_value: 140,
    end_date: (Time.now) + 300000,
    title: "Diminuez votre tension à 140mmHg",
    cumulative: false
  )
  goal.save

  measure = Measure.new(
    value: 152,
    date: (Time.now),
    user_id: 2,
    source: "Withings",
    measure_type_id: measure_type.id
  )
  measure.save


end
