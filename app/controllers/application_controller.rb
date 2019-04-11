class ApplicationController < ActionController::Base
  before_action :set_locale, except: [:descriptions]
  def set_locale
    I18n.locale = params&.[](:user)&.[](:lang) || current_user&.lang || (request&.env&.[]('HTTP_ACCEPT_LANGUAGE')&.slice(0,2) == 'ja' ? 'ja' : 'en')
  end
end