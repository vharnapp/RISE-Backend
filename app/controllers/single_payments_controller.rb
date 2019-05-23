class SinglePaymentsController < ApplicationController
  skip_authorization_check
  skip_before_action :check_subscription

  def index
    if current_user.active_subscription?
      redirect_to edit_user_registration_path
    end

    @single_payments = SinglePayment.all
  end

  def create
    payment_id = params[:payment_id]
    token = params[:stripeToken]
    single_payment = SinglePayment.find(payment_id)

    stripe_response = Stripe::Charge.create(
      amount: Integer(single_payment.price * 100),
      currency: 'usd',
      description: "#{single_payment.name} - Charge for #{current_user.email}",
      receipt_email: current_user.email,
      source: token,
    )

    current_user.update_column(:stripe_payment_id, stripe_response.id)
    current_user.update_column(:single_payment_id, payment_id)

    single_payment.pyramid_modules.each do |pyramid_module|
      if UnlockedPyramidModule.where(pyramid_module_id: pyramid_module.id).where(user_id: current_user.id).empty? 
        UnlockedPyramidModule.create(pyramid_module_id: pyramid_module.id, user_id: current_user.id)
      end
    end

    flash[:notice] = ' successfully created.'
    redirect_to edit_user_registration_path

    rescue => e
      flash[:error] = "Sorry, something went wrong. Please forward these error details to info@risefutbol.com.<br><br>Error: #{e}".html_safe
      redirect_to '/help'

  end

end
