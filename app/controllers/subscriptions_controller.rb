class SubscriptionsController < ApplicationController
  skip_authorization_check

  def index
  end

  def create
    plan_type = params[:plan_type].upcase

    plan = "Stripe::Plans::#{plan_type}".constantize
    price = plan.amount / 100

    if plan_type.match?('MONTHLY')
      end_date = 1.month.from_now
    elsif plan_type.match?('ANNUALLY')
      end_date = 1.year.from_now
    elsif plan_type.match?('FOREVER')
      end_date = 100.years.from_now
      price = 280 # override price
    end

    customer = Stripe::Customer.create(
      description: "Customer for #{current_user.email}",
      source: params[:stripeToken] # obtained with Stripe.js
    )

    Stripe::Subscription.create(
      customer: customer.id,
      items: [
        {
          plan: params[:plan_type],
        },
      ],
    )
  end
end
