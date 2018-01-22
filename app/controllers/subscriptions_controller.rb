class SubscriptionsController < ApplicationController
  skip_authorization_check

  skip_before_action :check_subscription

  def index
  end

  def create
    plan_type = params[:plan_type]

    unless plan_type == 'forever'
      plan = "Stripe::Plans::#{plan_type.upcase}".constantize
      price = plan.amount / 100 rescue 0
    end

    if plan_type.match?('monthly')
      end_date = 1.month.from_now
    elsif plan_type.match?('annually')
      end_date = 1.year.from_now
    elsif plan_type.match?('forever')
      end_date = 100.years.from_now
      price = 250 # override price to fixed amount that Verek and Scott wanted
    end

    Subscription.create!(
      user: current_user,
      start_date: Time.zone.today,
      end_date: end_date,
      price: price,
    )

    customer =
      begin
        Stripe::Customer.retrieve(current_user.stripe_customer_id)
      rescue Stripe::InvalidRequestError
        # TODO: (2018-01-13) jon => log the Customer retrieve failure if current_user.stripe_customer_id.present?
        Stripe::Customer.create(
          description: current_user.full_name,
          email: current_user.email,
          source: params[:stripeToken], # obtained with Stripe.js
        )
      end

    current_user.update_column(:stripe_customer_id, customer.id)

    raise "Problem creating Stripe customer for #{current_user.email}." if customer.blank? || current_user.stripe_customer_id.blank?
    # TODO: (2018-01-13) jon => Log this

    if plan_type == 'forever'
      Stripe::Charge.create(
        amount: price * 100,
        currency: 'usd',
        customer: customer.id,
        description: "Charge for #{current_user.email}"
      )

      flash[:notice] = 'Lifetime subscription successfully created. Your subscription will never expire.'
    else
      Stripe::Subscription.create(
        customer: customer.id,
        items: [
          {
            plan: plan_type,
          },
        ],
      )

      flash[:notice] = "Subscription successfully created."
    end

    redirect_to edit_user_registration_path
  rescue => e
    flash[:error] = "Sorry, something went wrong. Please forward these error details to info@risefutbol.com.<br><br>Error: #{e}".html_safe
    redirect_to '/help'
  end
end
