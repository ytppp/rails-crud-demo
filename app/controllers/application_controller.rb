class ApplicationController < ActionController::Base
  include Authuser
  protect_from_forgery unless: -> { request.format.json? }
  before_action :authenticate_user!, unless: :devise_controller?
end
