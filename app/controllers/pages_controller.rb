class PagesController < ApplicationController
  include HighVoltage::StaticPage

  skip_authorization_check
  skip_before_action :authenticate_user!

  layout :layout_for_page

  before_action :persist_flash

  private

  def persist_flash
    this_page = params[:id]
    pages_to_persist_flash = %(help)
    gon.persist_flash = true if pages_to_persist_flash.include?(this_page)
  end

  def layout_for_page
    case params[:id]
    when 'welcome'
      'no_header_or_footer'
    else
      'application'
    end
  end
end
