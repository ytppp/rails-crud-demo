class Api::V1::UsersController < ApiController
  before_action :set_per_page, only: [:index]
  before_action :set_page, only: [:index]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :check_admin, only: [:index, :destroy]
  before_action :check_admin_or_owner, only: [:update]

  def index
    @users  = User.select(User.attribute_names - ["password_digest"]).offset(@page).limit(@per_page)
    render json: {error_code:0, data:@users, message:'ok'}, status: 200
  end

  def show
    render json: {error_code:0, data: @user, message: 'ok'}, status: 200
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: {error_code:0, data:@user, message:'ok'}, status: 201
    else
      render json: {error_code:0, data:@user.errors}, status: 201
    end
  end

  def update
    if @user.update(user_params)
      render json: {error_code:0, data:@user, message:'ok'}, status: 202
    else
      render json: {error_code:500, message:@user.errors}, status: 202
    end
  end

  def destroy
    @user.destroy
    render json: {error_code:0, message:'ok'}, status: 204
  end

  private
    def set_user
      # @user = User.find_by_id(params[:id].to_i)
      # @user = @user.attributes.except("password_digest")
      @user = User.select(User.attribute_names - ["password_digest"]).find_by_id(params[:id].to_i)
    end

    def is_admin?
      current_user&.role == 0
    end

    def is_owner?
      @user.id == current_user&.id
    end

    def check_admin
      head 403 unless is_admin?
    end

    def check_admin_or_owner
      head 403 unless is_admin? || is_owner?
    end

    def user_params
      params.require(:user).permit(:email, :password)
    end
end
