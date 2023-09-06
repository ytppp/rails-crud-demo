class PagesController < ApplicationController
  skip_before_action :authenticate_devise_user!

  def home
  end
end
