class ApiController < ApplicationController
  include Authuser
  protect_from_forgery unless: -> { request.format.json? }
end
