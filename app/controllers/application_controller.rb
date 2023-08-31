class ApplicationController < ActionController::Base
  include Authuser
  protect_from_forgery unless: -> { request.format.json? }
  before_action -> { sleep 3 }
end
