class SubscriptionsController < ApplicationController
  skip_authorization_check

  def index
  end

  def create
    case params[:plan_type]
    when 'monthly'
      end_date = 1.month.from_now
      plan = Stripe::Plans::MONTHLY
      price = plan.amount / 100
    when 'monthly_with_training'
      end_date = 1.month.from_now
      plan = Stripe::Plans::MONTHLY_WITH_TRAINING
      price = plan.amount / 100
    when 'annually'
      end_date = 1.year.from_now
      plan = Stripe::Plans::ANNUALLY
      price = plan.amount / 100
    when 'annually_with_training'
      end_date = 1.year.from_now
      plan = Stripe::Plans::ANNUALLY_WITH_TRAINING
      price = plan.amount / 100
    when 'forever'
      end_date = 100.years.from_now
      price = 280
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
