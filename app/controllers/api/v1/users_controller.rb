class Api::V1::UsersController < ApiController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :check_admin, only: [:index, :destroy]
  before_action :check_admin_or_owner, only: %i[update]

  def index
    # select(User.attribute_names - ["password_digest"])
    @users  = User.page(current_page).per_page(per_page)
    options = get_links_serializer_options 'api_v1_users_path', @users
    render json: serializer_user(@users, 0, 'ok', options), status: 200
  end

  def show
    render json: serializer_user(@user), status: 200
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: serializer_user(@user), status: 201
    else
      render json: {error_code:0, data:@user.errors}, status: 201
    end
  end

  def update
    if @user.update(user_params)
      render json: serializer_user(@user), status: 202
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
      @user = User.find_by_id(params[:id].to_i)
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

    def serializer_user(user, error_code = 0, message = 'ok', options = {})
      user_hash = UserSerializer.new(user, options).serializable_hash
      user_hash['error_code'] = error_code
      user_hash['message'] = message
      user_hash
    end
end
