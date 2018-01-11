# This file contains descriptions of all your stripe plans

# Example
# Stripe::Plans::PRIMO #=> 'primo'

# Stripe.Plans::MONTHLY
Stripe.plan :monthly do |plan|
  plan.name = 'RISE Monthly Subscription' # to appear on cc statements
  plan.amount = 1_500 # cents
  plan.interval = 'month' # 'day', 'week', 'month', 'year'
end

Stripe.plan :annually do |plan|
  plan.name = 'RISE Annual Subscription' # to appear on cc statements
  plan.amount = 12_000 # cents
  plan.interval = 'year' # 'day', 'week', 'month', 'year'
end

Stripe.plan :monthly_with_training do |plan|
  plan.name = 'RISE Monthly Subscription with Personal Training' # to appear on cc statements
  plan.amount = 3_500 # cents
  plan.interval = 'month' # 'day', 'week', 'month', 'year'
end

Stripe.plan :annually_with_training do |plan|
  plan.name = 'RISE Annual Subscription with Personal Training' # to appear on cc statements
  plan.amount = 28_000 # cents
  plan.interval = 'year' # 'day', 'week', 'month', 'year'
end

# Stripe.plan :yearly do |plan|
#   # plan name as it will appear on credit card statements
#   plan.name = 'Acme as a service PRIMO'
#
#   # amount in cents. This is 6.99
#   plan.amount = 699
#
#   # currency to use for the plan (default 'usd')
#   plan.currency = 'usd'
#
#   # interval must be either 'day', 'week', 'month' or 'year'
#   plan.interval = 'month'
#
#   # only bill once every three months (default 1)
#   plan.interval_count = 3
#
#   # number of days before charging customer's card (default 0)
#   plan.trial_period_days = 30
# end
#
# Once you have your plans defined, you can run
#
#   rake stripe:prepare
#
# This will export any new plans to stripe.com so that you can
# begin using them in your API calls.
