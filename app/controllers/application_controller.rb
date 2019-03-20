class ApplicationController < ActionController::Base
  before_action :set_locale
  def set_locale
    I18n.locale = current_user&.lang || request.env['HTTP_ACCEPT_LANGUAGE'].to_s[0,2] == 'ja' ? 'ja' : 'en'
  end
end