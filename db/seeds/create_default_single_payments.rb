# You can use this seed with this command in command line
#$ rake db:seed:create_default_single_payments
# Don't worry, it will not dulicate anything

def self.include_pyramid_module(single_payment, pyramid_module)

  if pyramid_module.nil?
    return 0
  end

  if !(single_payment.pyramid_module.include? pyramid_module)
    # if does not includes pyramid module
    single_payment.pyramid_module << pyramid_module
    return 1
  end
  return 0
end

single_payment_attributes = [
  { name: "10 Day Development Guide", price: 0, thank_you_link: "", string_id: "" },
  { name: "SKILL & SPEED", price: 49.95, thank_you_link: "https://risefutbol.com/THANKYOU-SKILL" },
  { name: "SPEED & STRENGTH", price: 49.95, thank_you_link: "https://risefutbol.com/THANKYOU-STRENGTH" },
  { name: "COMPLETE TRAINING PROGRAM", price: 89.95, thank_you_link: "https://risefutbol.com/THANKYOU-FULLACCESS" },
  { name: "FULL PROGRAM - COACHES EDITION", price: 99.95, thank_you_link: "http://risefutbol.com/THANKYOU-COACHES" },
]

pyramid_module_passing               = PyramidModule.where({level: 1, name: "Passing"}).first
pyramid_module_ball_control          = PyramidModule.where({level: 1, name: "Ball Control"}).first
pyramid_module_quickness             = PyramidModule.where({level: 1, name: "Quickness"}).first
pyramid_module_speed_strength        = PyramidModule.where({level: 1, name: "Speed-Strength"}).first
pyramid_module_general_strength      = PyramidModule.where({level: 1, name: "General Strength"}).first
puts "Level 1 Workout Passing is missing!!" if pyramid_module_passing.nil?
puts "Level 1 Workout Ball Control is missing!!" if pyramid_module_ball_control.nil?
puts "Level 1 Workout Quickness is missing!!" if pyramid_module_quickness.nil?
puts "Level 1 Workout Speed-Strength is missing!!" if pyramid_module_speed_strength.nil?
puts "Level 1 Workout General Strength is missing!!" if pyramid_module_general_strength.nil?

pyramid_module_passing_combos        = PyramidModule.where({level: 2, name: "Passing Combos"}).first
pyramid_module_quick_skills          = PyramidModule.where({level: 2, name: "Quick Skills"}).first
pyramid_module_explosive_agility     = PyramidModule.where({level: 2, name: "Explosive Agility"}).first
pyramid_module_power_endurance       = PyramidModule.where({level: 2, name: "Power Endurance"}).first
puts "Level 2 Workout Passing Combos is missing!!" if pyramid_module_passing_combos.nil?
puts "Level 2 Workout Quick Skills is missing!!" if pyramid_module_quick_skills.nil?
puts "Level 2 Workout Explosive Agility is missing!!" if pyramid_module_explosive_agility.nil?
puts "Level 2 Workout Power Endurance is missing!!" if pyramid_module_power_endurance.nil?

pyramid_module_soccer_conditioning   = PyramidModule.where({level: 3, name: "Soccer Conditioning"}).first
pyramid_module_speed                 = PyramidModule.where({level: 3, name: "Speed"}).first
pyramid_module_athletic_power        = PyramidModule.where({level: 3, name: "Athletic Power"}).first
if pyramid_module_soccer_conditioning.nil?
  pyramid_module_soccer_conditioning   = PyramidModule.where({level: 3, name: "Soccer Fitness"}).first

  if pyramid_module_soccer_conditioning.nil?
    puts "Level 3 Workout Soccer Conditioning / Soccer Fitness is missing!!"
  else
    puts "Level 3 Workout Soccer Conditioning was renamed to Soccer Fitness!!"
  end
end
puts "Level 3 Workout Speed is missing!!" if pyramid_module_speed.nil?
puts "Level 3 Workout Athletic Power is missing!!" if pyramid_module_athletic_power.nil?

pyramid_module_coaching_skill        = PyramidModule.where({level: 4, name: "Coaching Skill"}).first
pyramid_module_coaching_athleticism  = PyramidModule.where({level: 4, name: "Coaching Athleticism"}).first
puts "Level 4 Workout Coaching Skill is missing!!" if pyramid_module_coaching_skill.nil?
puts "Level 4 Workout Coaching Athleticism is missing!!" if pyramid_module_coaching_athleticism.nil?

pyramid_module_team_sessions         = PyramidModule.where({level: 5, name: "Team Sessions"}).first
puts "Level 5 Workout Team Sessions is missing!!" if pyramid_module_team_sessions.nil?

single_payment_attributes.each do |attributes|
  @single_payment = SinglePayment.where(attributes).first_or_create
  puts "GERAPPA"
  single_payment = SinglePayment.find(@single_payment.id)
  puts single_payment.to_json

  case @single_payment.name

    when "SKILL & SPEED"
      count = 0
      count += include_pyramid_module(@single_payment, pyramid_module_passing)
      count += include_pyramid_module(@single_payment, pyramid_module_ball_control)
      count += include_pyramid_module(@single_payment, pyramid_module_quickness)

      count += include_pyramid_module(@single_payment, pyramid_module_passing_combos)
      count += include_pyramid_module(@single_payment, pyramid_module_quick_skills)

      count += include_pyramid_module(@single_payment, pyramid_module_soccer_conditioning)
      count += include_pyramid_module(@single_payment, pyramid_module_speed)

      puts "#{count} / 7 Workouts added to SPEED & STRENGTH Single Payment"
    # end when "COMPLETE TRAINING PROGRAM"
    
    when "SPEED & STRENGTH"
      count = 0
      count += include_pyramid_module(@single_payment, pyramid_module_quickness)
      count += include_pyramid_module(@single_payment, pyramid_module_speed_strength)
      count += include_pyramid_module(@single_payment, pyramid_module_general_strength)

      count += include_pyramid_module(@single_payment, pyramid_module_explosive_agility)
      count += include_pyramid_module(@single_payment, pyramid_module_power_endurance)

      count += include_pyramid_module(@single_payment, pyramid_module_speed)
      count += include_pyramid_module(@single_payment, pyramid_module_athletic_power)

      puts "#{count} / 7 Workouts added to SPEED & STRENGTH Single Payment"
    # end when "COMPLETE TRAINING PROGRAM"
    
    when "COMPLETE TRAINING PROGRAM"
      count = 0
      count += include_pyramid_module(@single_payment, pyramid_module_passing)
      count += include_pyramid_module(@single_payment, pyramid_module_ball_control)
      count += include_pyramid_module(@single_payment, pyramid_module_quickness)
      count += include_pyramid_module(@single_payment, pyramid_module_speed_strength)
      count += include_pyramid_module(@single_payment, pyramid_module_general_strength)

      count += include_pyramid_module(@single_payment, pyramid_module_passing_combos)
      count += include_pyramid_module(@single_payment, pyramid_module_quick_skills)
      count += include_pyramid_module(@single_payment, pyramid_module_explosive_agility)
      count += include_pyramid_module(@single_payment, pyramid_module_power_endurance)

      count += include_pyramid_module(@single_payment, pyramid_module_soccer_conditioning)
      count += include_pyramid_module(@single_payment, pyramid_module_speed)
      count += include_pyramid_module(@single_payment, pyramid_module_athletic_power)

      puts "#{count} / 12 Workouts added to COMPLETE TRAINING PROGRAM Single Payment"
    # end when "COMPLETE TRAINING PROGRAM"

    when "FULL PROGRAM - COACHES EDITION"
      count = 0
      count += include_pyramid_module(@single_payment, pyramid_module_passing)
      count += include_pyramid_module(@single_payment, pyramid_module_ball_control)
      count += include_pyramid_module(@single_payment, pyramid_module_quickness)
      count += include_pyramid_module(@single_payment, pyramid_module_speed_strength)
      count += include_pyramid_module(@single_payment, pyramid_module_general_strength)

      count += include_pyramid_module(@single_payment, pyramid_module_passing_combos)
      count += include_pyramid_module(@single_payment, pyramid_module_quick_skills)
      count += include_pyramid_module(@single_payment, pyramid_module_explosive_agility)
      count += include_pyramid_module(@single_payment, pyramid_module_power_endurance)

      count += include_pyramid_module(@single_payment, pyramid_module_soccer_conditioning)
      count += include_pyramid_module(@single_payment, pyramid_module_speed)
      count += include_pyramid_module(@single_payment, pyramid_module_athletic_power)

      count += include_pyramid_module(@single_payment, pyramid_module_coaching_skill)
      count += include_pyramid_module(@single_payment, pyramid_module_coaching_athleticism)

      count += include_pyramid_module(@single_payment, pyramid_module_team_sessions)

      puts "#{count} / 15 Workouts added to FULL PROGRAM - COACHES EDITION Single Payment"
    # end when "FULL PROGRAM - COACHES EDITION"
  end
end
