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
  before_action :set_clubs

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

      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  protected

  def set_clubs
    @clubs = [] and return unless current_user

    @clubs =
      if current_user.admin?
        Club.all
      else
        affiliated_club_ids = current_user.clubs.map(&:id) # player/coach
        administered_club_ids = current_user.administered_clubs.map(&:id)
        ids = (affiliated_club_ids + administered_club_ids).uniq
        Club.where(id: ids)
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
end
