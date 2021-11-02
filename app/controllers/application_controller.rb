# rubocop:disable Metrics/ClassLength, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/LineLength
class ApplicationController < ActionController::Base
  include AnalyticsTrack

  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  check_authorization unless: :devise_or_pages_controller?
  impersonates :user

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: -> { is_a?(HighVoltage::PagesController) }
  before_action :add_layout_name_to_gon
  before_action :detect_device_type
  before_action :set_clubs, unless: -> { request.format.json? }
  before_action :check_subscription, unless: -> { request.format.json? || devise_or_pages_controller? }

  respond_to :json, :html, if: :devise_controller? # for devise reset password

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json do
        render json: {
          errors: [
            title: exception.message,
            status: '403',
          ],
        }, status: :forbidden
      end

      format.html { redirect_to '/unauthorized', alert: exception.message }
    end
  end

  protected

  def set_clubs
    @clubs = [] and return unless current_user

    @clubs ||=
      if current_user.admin?
        Club.all.order(:name)
      else
        affiliated_club_ids = current_user.clubs_coached.map(&:id) # coach
        clubs_administered_ids = current_user.clubs_administered.map(&:id)
        ids = (affiliated_club_ids + clubs_administered_ids).uniq
        Club.where(id: ids).order(:name)
      end
  end

  def check_subscription
    return if @clubs.present? # club admin or coach

    # Player
    if current_user && !request.path.match?('analytics_alias')
      if current_user.active_subscription?
        redirect_to edit_user_registration_path and return
      else
        if current_user.team_player?
          redirect_to edit_user_registration_path and return
        else
          redirect_to single_payments_path and return
        end
      end
    end
  end

  def devise_or_pages_controller?
    devise_controller? == true || is_a?(HighVoltage::PagesController)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: %i[
        first_name
        last_name
        email
        password
        password_confirmation
        remember_me
      ],
    )

    devise_parameter_sanitizer.permit(
      :sign_in,
      keys: %i[
        login email password remember_me
      ],
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[
        first_name
        last_name
        email
        avatar
        password
        password_confirmation
        current_password
      ],
    )
  end

  def add_layout_name_to_gon
    gon.layout =
      case devise_controller?
      when true
        'devise'
      else
        'application'
      end
  end

  def detect_device_type
    request.variant =
      case request.user_agent
      when /iPad/i
        :tablet
      when /iPhone/i
        :phone
      when /Android/i && /mobile/i
        :phone
      when /Android/i
        :tablet
      when /Windows Phone/i
        :phone
      end
  end

  def handle_unverified_request
    flash[:error] = 'You have been signed out of your current session'
    redirect_to "/"
  end
end
