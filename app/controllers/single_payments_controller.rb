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

    if complete_traning_program_package.id.nil?
      render_text = 'Complete training program was deleted or renamed. Aborting Process'
    else
      subs.each do |subscription|
        # Check if subscription's user exists
        if !subscription.user.nil?
          this_user = subscription.user
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
              stripe_sub.delete()

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

end
