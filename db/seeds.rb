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
    email: "estelle@mail.com",
    password: "estestest",
    first_name: "Estelle",
    last_name: "Landreau",
    birthday: Time.new(1975, 10, 20),
    sexe: "female",
    is_adviser: true,
    height: 170
  )
  coach_user.save

  coach_adviser = Adviser.new(
    title: "Nutritionist",
    user_id: coach_user.id,
    description: "I'm here to provide support, information, and encouragement to help facilitate your success. I know by the end of this journey, you will have lots of new tools and strategies that you can use in your everyday life."
  )
  coach_adviser.save

  patient_user = User.new(
    email: "ousmane@mail.com",
    password: "ousousous",
    adviser_id: coach_adviser.id,
    first_name: "Ousmane",
    last_name: "Medhanie",
    birthday: Time.new(1990, 12, 12),
    sexe: "male",
    height: 172
  )
  patient_user.save

  patient_user = User.new(
    email: "remi@mail.com",
    password: "remremrem",
    adviser_id: coach_adviser.id,
    first_name: "Remi",
    last_name: "Tremblay",
    birthday: Time.new(1987, 10, 8),
    sexe: "male",
    height: 172
  )
  patient_user.save

  patient_user = User.new(
    email: "william@mail.com",
    password: "wilwilwil",
    adviser_id: coach_adviser.id,
    first_name: "William",
    last_name: "Chauvel",
    birthday: Time.new(1985, 7, 16),
    sexe: "male",
    height: 180
  )
  patient_user.save

  coach_user = User.new(
    email: "mike@mail.com",
    password: "mikmikmik",
    first_name: "Michael",
    last_name: "Taylor",
    birthday: Time.new(1955, 10, 20),
    sexe: "male",
    is_adviser: true,
    height: 170
  )
  coach_user.save

  coach_adviser = Adviser.new(
    title: "Diabetes Specialist",
    user_id: coach_user.id,
    description: "I believe people’s paths cross for a purpose and as your techcare coach, my mission is to support you to reach your goals and make positive changes in your life."
  )
  coach_adviser.save

  coach_user = User.new(
    email: "john@mail.com",
    password: "johjohjoh",
    first_name: "John",
    last_name: "Moore",
    birthday: Time.new(1975, 10, 20),
    sexe: "male",
    is_adviser: true,
    height: 170
  )
  coach_user.save

  coach_adviser = Adviser.new(
    title: "Cardiologist",
    user_id: coach_user.id,
    description: "I have treated hundreds of patients and studied web-based therapy programs for over a decade, and I know that personal attention and the use of evidence based techniques significantly improve mental health outcomes."
  )
  coach_adviser.save
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
    date: (Time.now) - 800000,
    user_id: 2,
    source: "Withings",
    measure_type_id: measure_type.id
  )
  measure.save

  goal = Goal.new(
    measure_type_id: 1,
    user_id: 2,
    adviser_id: 1,
    start_date: (Time.now) - 400000,
    end_value: 80,
    end_date: (Time.now) + 300000,
    title: "Keep your weight under 80kg",
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
    title: "Decrease your blood pressure to 140mmHg",
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

1.times do
  measure_type = MeasureType.new(
    name: "Fat ratio",
    unit: "%",
    data_type: "FatRatioTest"
  )
  measure_type.save

  measure = Measure.new(
    value: 40,
    date: (Time.now) - 800000,
    user_id: 2,
    source: "Withings",
    measure_type_id: measure_type.id
  )
  measure.save

  goal = Goal.new(
    measure_type_id: measure_type.id,
    user_id: 2,
    adviser_id: 1,
    start_date: (Time.now) - 400000,
    end_value: 25,
    end_date: (Time.now) + 300000,
    title: "Reach a fat mass ratio of 25%",
    cumulative: false
  )
  goal.save

  measure = Measure.new(
    value: 35,
    date: (Time.now),
    user_id: 2,
    source: "Withings",
    measure_type_id: measure_type.id
  )
  measure.save
end
