class ApplicationController < ActionController::Base
  before_action :set_locale
  def set_locale
    I18n.locale = current_user&.lang || request.env['HTTP_ACCEPT_LANGUAGE'].to_s.slice(0,2)
  end
end