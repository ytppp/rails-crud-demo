class ApplicationController < ActionController::Base
  include Authuser
  protect_from_forgery unless: -> { request.format.json? }
end
