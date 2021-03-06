# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# measure_type: poids (id: 1)
measure_type_1 = MeasureType.new(
  name: "weight",
  unit: "kg",
  data_type: "test"
)
measure_type_1.save

# measure_type: tension (id: 2)
measure_type_2 = MeasureType.new(
  name: "blood_pressure",
  unit: "mmHg",
  data_type: "tensiontest"
)
measure_type_2.save

# measure_type: Fat (id: 3)
measure_type_3 = MeasureType.new(
  name: "fat_ratio",
  unit: "%",
  data_type: "FatRatioTest"
)
measure_type_3.save

# measure_type: Steps (id: 4)
measure_type_4 = MeasureType.new(
  name: "steps",
  unit: "steps",
  data_type: "StepsTest"
)
measure_type_4.save

# measure_type: FoodPicture (id: 5)
measure_type_5 = MeasureType.new(
  name: "Food picture",
  unit: "picture",
  data_type: "image"
)
measure_type_5.save

coach_user_1 = User.new(
  email: "ppavadepoulle@life-e.fr",
  password: "prakasch",
  first_name: "Prakasch",
  last_name: "Pavadepoulle",
  birthday: Time.new(1985, 10, 20),
  sexe: "male",
  is_adviser: true,
  height: 170
)
coach_user_1.save

coach_adviser_1 = Adviser.new(
  title: "Diététicien et coach sportif",
  user_id: coach_user_1.id,
  description: "J'anime des ateliers diététiques et j'ai participé à l’étude Nutrinet-Santé, l'Unité de Recherche en Épidémiologie Nutritionnelle (UREN) du Pr S. Hercberg."
)
coach_adviser_1.save

coach_user_2 = User.new(
  email: "ysorin@life-e.fr",
  password: "yohansorin",
  first_name: "Yohan",
  last_name: "Sorin",
  birthday: Time.new(1985, 10, 20),
  sexe: "male",
  is_adviser: true,
  height: 170
)
coach_user_2.save

coach_adviser_2 = Adviser.new(
  title: "Coach sportif, préparateur physique & mental",
  user_id: coach_user_2.id,
  description: "I believe people’s paths cross for a purpose and as your techcare coach, my mission is to support you to reach your goals and make positive changes in your life."
)
coach_adviser_2.save

coach_user_3 = User.new(
  email: "jlalous@life-e.fr",
  password: "julienlalous",
  first_name: "Julien",
  last_name: "Lalous",
  birthday: Time.new(1985, 10, 20),
  sexe: "male",
  is_adviser: true,
  height: 170
)
coach_user_3.save

coach_adviser_3 = Adviser.new(
  title: "Diététicien nutritionniste",
  user_id: coach_user_3.id,
  description: "I have treated hundreds of patients and studied web-based therapy programs for over a decade, and I know that personal attention and the use of evidence based techniques significantly improve mental health outcomes."
)
coach_adviser_3.save

user_4 = User.new(
  email: "grenier.godard@gmail.com",
  password: "billyboy",
  first_name: "William",
  last_name: "Godard",
  birthday: Time.new(1985, 07, 16),
  sexe: "male",
  is_adviser: false,
  adviser_id: 3,
  height: 180
)
user_4.save

sub = Subscription.new(
      start_date: Time.current,
      user_id: user_4.id,
      active: true,
      name: 'sub-6',
      stripe_id: 'fake'
      )
sub.save

measure = Measure.new(
            value: 90,
            date: Time.current,
            user_id: user_4.id,
            measure_type_id: 1
            )
measure.save

measure = Measure.new(
            value: 5000,
            date: Time.current,
            user_id: user_4.id,
            measure_type_id: 4,
            )
measure.save

goal = Goal.new(
        measure_type_id: 1,
        user_id: user_4.id,
        adviser_id: user_4.adviser_id,
        cumulative: false,
        goal_value: (25 * ( ( user_4.height.to_f / 100 ) ** 2) ).round,
        end_date: Time.current + 2.months,
        start_date: Time.current
       )
goal.save

user_5 = User.new(
  email: "grenier_godard@hotmail.fr",
  password: "billyboy",
  first_name: "Will",
  last_name: "Hotmail",
  birthday: Time.new(1985, 07, 16),
  sexe: "male",
  is_adviser: false,
  adviser_id: 3,
  height: 180
)
user_5.save

sub = Subscription.new(
      start_date: Time.current,
      user_id: user_5.id,
      active: true,
      name: 'sub-6',
      stripe_id: 'fake_id'
      )
sub.save
