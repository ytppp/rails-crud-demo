class ApplicationController < ActionController::Base
  include Authuser
  protect_from_forgery unless: -> { request.format.json? }
  before_action :authenticate_user!, unless: :devise_controller?

  helper_method :current_company

  private
    def current_company
      @current_company ||= current_devise_user.company if devise_user_signed_in?
    end
end
