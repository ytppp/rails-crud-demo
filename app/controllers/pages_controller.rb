class PagesController < TurboController
  skip_before_action :authenticate_devise_user!

  def home
  end
end
