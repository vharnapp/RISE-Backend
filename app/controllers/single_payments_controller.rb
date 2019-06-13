class SinglePaymentsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:replace_existing]

  skip_authorization_check
  skip_before_action :check_subscription


  def index
    #if current_user.active_subscription?
    #  redirect_to edit_user_registration_path
    #end

    @single_payments = SinglePayment.where("price > 0")
  end

  def create
    payment_id = params[:payment_id]
    token = params[:stripeToken]
    single_payment = SinglePayment.find(payment_id)

    if current_user.has_archieved_user_payment(single_payment.id)
      flash[:error] = "You already purchased this package!"
    end

    stripe_response = Stripe::Charge.create(
      amount: Integer(single_payment.price * 100),
      currency: 'usd',
      description: "#{single_payment.name} - Charge for #{current_user.email}",
      receipt_email: current_user.email,
      source: token,
    )

    current_user.update_column(:stripe_payment_id, stripe_response.id)
    current_user.update_column(:single_payment_id, payment_id)
    ArchievedUserPayment.create(single_payment_id: single_payment.id, user_id: current_user.id, payment_name: single_payment.name, payment_price: single_payment.price, payment_stripe_id: stripe_response.id)

    single_payment.pyramid_modules.each do |pyramid_module|
      if UnlockedPyramidModule.where(pyramid_module_id: pyramid_module.id).where(user_id: current_user.id).empty? 
        UnlockedPyramidModule.create(pyramid_module_id: pyramid_module.id, user_id: current_user.id, has_restriction: 0)
      else
        UnlockedPyramidModule.where(pyramid_module_id: pyramid_module.id).where(user_id: current_user.id).update(has_restriction: 0)
      end
    end

    flash[:notice] = ' successfully created.'
    redirect_to "/purchase_confirmation/#{single_payment.name.parameterize}"

    rescue => e
      flash[:error] = "Sorry, something went wrong. Please forward these error details to info@risefutbol.com.<br><br>Error: #{e}".html_safe
      redirect_to '/help'

  end

  def purchase_confirmation
    current_single_payment = []

    SinglePayment.find_each do |current|
      if current.name.parameterize == params[:slug]
        @current_single_payment = current
      end
    end

    if @current_single_payment.nil?
      redirect_to edit_user_registration_path
    end
  end

  def replace_existing
    subs = Subscription.where(club_id: nil)
    render_text = ''
    count_subscribed_users = 0

    complete_traning_program_package = SinglePayment.where(name: "COMPLETE TRAINING PROGRAM").first
    puts complete_traning_program_package.to_json
abc = 0
    if complete_traning_program_package.id.nil?
      render_text = 'Complete training program was deleted or renamed. Aborting Process'
    else
      subs.each do |subscription|
        abc = abc + 1
        puts "nr. #{abc}, Subscriptionid: #{subscription.id}, subscription user_id: #{subscription.user_id}"
        puts " "
        # Check if subscription's user exists
        if !subscription.user.nil? && !subscription.user.stripe_customer_id.nil?
          this_user = subscription.user
          puts "User stripe_customer_id: #{this_user.stripe_customer_id}"
          puts " "
          puts " "
          stripe = Stripe::Customer.retrieve(this_user.stripe_customer_id)
          if stripe.subscriptions.count > 0
            stripe_sub = stripe.subscriptions.first
            stripe_sub_end_date = Time.at(stripe_sub.current_period_end)
            stripe_sub_end_date = stripe_sub_end_date.to_date
            today = Date.today
            # Check if
            if(stripe_sub_end_date > today) 
              render_text += "#{this_user.first_name} #{this_user.last_name}, ends at #{stripe_sub_end_date}\n"
              # Delete Stripe Subscription
              #stripe_sub.delete()

              # Update users table set stripe_paymetn_id as old stripe subscription id and single_payment_id 
              this_user.update_column(:stripe_payment_id, stripe_sub.id)
              this_user.update_column(:single_payment_id, complete_traning_program_package.id)
              ArchievedUserPayment.create(single_payment_id: complete_traning_program_package.id, user_id: current_user.id, payment_name: complete_traning_program_package.name, payment_price: complete_traning_program_package.price, payment_stripe_id: stripe_sub.id)
              # Unlock all pyramid modules of the new package which hasn't been unlocked yet
              complete_traning_program_package.pyramid_modules.each do |pyramid_module|
                if UnlockedPyramidModule.where(pyramid_module_id: pyramid_module.id).where(user_id: current_user.id).empty? 
                  UnlockedPyramidModule.create(pyramid_module_id: pyramid_module.id, user_id: current_user.id, has_restriction: 0)
                else
                  UnlockedPyramidModule.where(pyramid_module_id: pyramid_module.id).where(user_id: current_user.id).update(has_restriction: 0)
                end
              end

              count_subscribed_users = count_subscribed_users + 1
            end
          end
        end

        abc = abc+1
      end

      render_text += "\n\n Total number of subscribers were updated to Complete Training Program: #{count_subscribed_users}"
      render_text += "\n Note: if the number if 0, that means that all subcribers were updated to Complete Training Program"

      count_unsubscribed_users = 0
      free_package = SinglePayment.where(name: "10 Day Development Guide").first
      puts free_package.to_json

      if free_package.id.nil?
        render_text += "\n\nFree program was deleted or renamed. Aborting Process"
        render plain: render_text
      else
        users = User.where(single_payment_id: nil).order(:id)

        users.each do |user|
          if user.teams.count == 0
            user.update_column(:single_payment_id, free_package.id)
            # Unlock all pyramid modules of the new package which hasn't been unlocked yet
            free_package.pyramid_modules.each do |pyramid_module|
              if UnlockedPyramidModule.where(pyramid_module_id: pyramid_module.id).where(user_id: user.id).empty? 
                UnlockedPyramidModule.create(pyramid_module_id: pyramid_module.id, user_id: user.id, has_restriction: 1)
              else
                UnlockedPyramidModule.where(pyramid_module_id: pyramid_module.id).where(user_id: user.id).update(has_restriction: 1)
              end
            end

            count_unsubscribed_users = count_unsubscribed_users + 1
          end
        end
      end

      render_text += "\n\n Total number of unsubscribed users recieved \"10 Day Development Guide\" program: #{count_unsubscribed_users}"
      render_text += "\n Note: if the number if 0, that means that there is no unsubscribed user who does not recieved \"10 Day Development Guide\" program"

      render plain: render_text
    end
  end

  def generate_default_single_payments
    single_payment_attributes = [
      { name: "10 Day Development Guide", price: 0 },
      { name: "SKILL & SPEED", price: 49.95 },
      { name: "SPEED & STRENGTH", price: 49.95 },
      { name: "COMPLETE TRAINING PROGRAM", price: 99.95 },
      { name: "FULL PROGRAM - COACHES EDITION", price: 149.95 },
    ]
    render_text = ""

    pyramid_module_passing               = PyramidModule.where({level: 1, name: "Passing"}).first
    pyramid_module_ball_control          = PyramidModule.where({level: 1, name: "Ball Control"}).first
    pyramid_module_quickness             = PyramidModule.where({level: 1, name: "Quickness"}).first
    pyramid_module_speed_strength        = PyramidModule.where({level: 1, name: "Speed-Strength"}).first
    pyramid_module_general_strength      = PyramidModule.where({level: 1, name: "General Strength"}).first
    render_text += "\nLevel 1 Workout Passing is missing!!" if pyramid_module_passing.nil?
    render_text += "\nLevel 1 Workout Ball Control is missing!!" if pyramid_module_ball_control.nil?
    render_text += "\nLevel 1 Workout Quickness is missing!!" if pyramid_module_quickness.nil?
    render_text += "\nLevel 1 Workout Speed-Strength is missing!!" if pyramid_module_speed_strength.nil?
    render_text += "\nLevel 1 Workout General Strength is missing!!" if pyramid_module_general_strength.nil?

    pyramid_module_passing_combos        = PyramidModule.where({level: 2, name: "Passing Combos"}).first
    pyramid_module_quick_skills          = PyramidModule.where({level: 2, name: "Quick Skills"}).first
    pyramid_module_explosive_agility     = PyramidModule.where({level: 2, name: "Explosive Agility"}).first
    pyramid_module_power_endurance       = PyramidModule.where({level: 2, name: "Power Endurance"}).first
    render_text += "\nLevel 2 Workout Passing Combos is missing!!" if pyramid_module_passing_combos.nil?
    render_text += "\nLevel 2 Workout Quick Skills is missing!!" if pyramid_module_quick_skills.nil?
    render_text += "\nLevel 2 Workout Explosive Agility is missing!!" if pyramid_module_explosive_agility.nil?
    render_text += "\nLevel 2 Workout Power Endurance is missing!!" if pyramid_module_power_endurance.nil?

    pyramid_module_soccer_conditioning   = PyramidModule.where({level: 3, name: "Soccer Conditioning"}).first
    pyramid_module_speed                 = PyramidModule.where({level: 3, name: "Speed"}).first
    pyramid_module_athletic_power        = PyramidModule.where({level: 3, name: "Athletic Power"}).first
    if pyramid_module_soccer_conditioning.nil?
      pyramid_module_soccer_conditioning   = PyramidModule.where({level: 3, name: "Soccer Fitness"}).first

puts render_text
      if pyramid_module_soccer_conditioning.nil?
        render_text += "\nLevel 3 Workout Soccer Conditioning / Soccer Fitness is missing!!"
      else
        #render_text += "\nLevel 3 Workout Soccer Conditioning was renamed to Soccer Fitness!!"
      end
    end
    render_text += "\nLevel 3 Workout Speed is missing!!" if pyramid_module_speed.nil?
    render_text += "\nLevel 3 Workout Athletic Power is missing!!" if pyramid_module_athletic_power.nil?

    pyramid_module_coaching_skill        = PyramidModule.where({level: 4, name: "Coaching Skill"}).first
    pyramid_module_coaching_athleticism  = PyramidModule.where({level: 4, name: "Coaching Athleticism"}).first
    render_text += "\nLevel 4 Workout Coaching Skill is missing!!" if pyramid_module_coaching_skill.nil?
    render_text += "\nLevel 4 Workout Coaching Athleticism is missing!!" if pyramid_module_coaching_athleticism.nil?

    pyramid_module_team_sessions         = PyramidModule.where({level: 5, name: "Team Sessions"}).first
    render_text += "\nLevel 5 Workout Team Sessions is missing!!" if pyramid_module_team_sessions.nil?

    single_payment_attributes.each do |attributes|
      @single_payment = SinglePayment.where(attributes).first_or_create

      case @single_payment.name

        when "10 Day Development Guide"
          count = 0
          count += include_pyramid_module(@single_payment, pyramid_module_passing)
          count += include_pyramid_module(@single_payment, pyramid_module_ball_control)
          count += include_pyramid_module(@single_payment, pyramid_module_quickness)
          count += include_pyramid_module(@single_payment, pyramid_module_speed_strength)
          count += include_pyramid_module(@single_payment, pyramid_module_general_strength)

          render_text += "\n#{count} / 5 Workouts added to 10 Day Development Guide Single Payment"


        when "SKILL & SPEED"
          count = 0
          count += include_pyramid_module(@single_payment, pyramid_module_passing)
          count += include_pyramid_module(@single_payment, pyramid_module_ball_control)
          count += include_pyramid_module(@single_payment, pyramid_module_quickness)

          count += include_pyramid_module(@single_payment, pyramid_module_passing_combos)
          count += include_pyramid_module(@single_payment, pyramid_module_quick_skills)

          count += include_pyramid_module(@single_payment, pyramid_module_soccer_conditioning)
          count += include_pyramid_module(@single_payment, pyramid_module_speed)

          render_text += "\n#{count} / 7 Workouts added to SKILL & SPEED Single Payment"
        # end when "SKILL & SPEED PROGRAM"
        
        when "SPEED & STRENGTH"
          count = 0
          count += include_pyramid_module(@single_payment, pyramid_module_quickness)
          count += include_pyramid_module(@single_payment, pyramid_module_speed_strength)
          count += include_pyramid_module(@single_payment, pyramid_module_general_strength)

          count += include_pyramid_module(@single_payment, pyramid_module_explosive_agility)
          count += include_pyramid_module(@single_payment, pyramid_module_power_endurance)

          count += include_pyramid_module(@single_payment, pyramid_module_speed)
          count += include_pyramid_module(@single_payment, pyramid_module_athletic_power)

          render_text += "\n#{count} / 7 Workouts added to SPEED & STRENGTH Single Payment"
        # end when "SPEED & STRENGTH"
        
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

          render_text += "\n#{count} / 12 Workouts added to COMPLETE TRAINING PROGRAM Single Payment"
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

          render_text += "\n#{count} / 15 Workouts added to FULL PROGRAM - COACHES EDITION Single Payment"
        # end when "FULL PROGRAM - COACHES EDITION"
      end
    end

    render plain: render_text
  end


  private

  def include_pyramid_module(single_payment, pyramid_module)

    if pyramid_module.nil?
      return 0
    end
    puts " "
    puts " "
    puts @single_payment.to_json
    puts " "
    puts " "

    if !(single_payment.pyramid_modules.include? pyramid_module)
      # if does not includes pyramid module
      single_payment.pyramid_modules << pyramid_module
      return 1
    end
    return 0
  end

end
