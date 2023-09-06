class TurboController < ApplicationController
  before_action :authenticate_devise_user!, unless: :devise_controller?

  helper_method :current_company

  private
    def current_company
      @current_company ||= current_devise_user.company if devise_user_signed_in?
    end
end
