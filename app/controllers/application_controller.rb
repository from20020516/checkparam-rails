# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale, except: [:descriptions]

  def set_locale
    I18n.locale =
      (params&.[](:user)&.[](:lang)&.to_sym) ||
      (params&.[](:lang)&.to_sym) ||
      (current_user&.lang&.to_sym) ||
      (request&.env&.[]('HTTP_ACCEPT_LANGUAGE')&.slice(0, 2) == 'ja' ? :ja : :en)
  end
end
