class PagesController < ApplicationController
  include HighVoltage::StaticPage

  skip_authorization_check
  skip_before_action :authenticate_user!

  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when 'welcome'
      'no_header_or_footer'
    else
      'application'
    end
  end
end
