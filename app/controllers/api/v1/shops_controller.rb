class Api::V1::ShopsController < ApiController
  before_action :set_shop, only: [:show, :update, :destroy]
  before_action :check_login, only: [:create]
  before_action :check_owner, only: [:update, :destroy]

  def index
    @shops = Shop.page(current_page).per_page(per_page)
    options = get_links_serializer_options 'api_v1_shops_path', @shops
    render json: serializer_shop(@shops, 0, 'ok', options), status: :ok
  end

  def show
    render json: serializer_shop(@shop), status: :ok
  end

  def create
    @user = current_user
    @shop = Shop.new(shop_params)
    @shop.user = @user
    @shop.transaction do
      @user.role = 2
      # save! 会在保存失败时抛出异常，适合用于需要确保保存成功的场景。
      # save 则更适合需要手动处理保存失败的场景
      if @shop.save! && @user.save!
        render json: serializer_shop(@shop), status: :created
      else
        render json: { error_code: 500, message: @shop.errors }, status: :created
      end
    end
  end

  def update
    @user = current_user
    if @user.shop.update(shop_params)
      render json: serializer_shop(@shop), status: :created
    else
      render json: { error_code: 500, message: @shop.errors }, status: :created
    end
  end

  def destroy
    @shop.destroy
    head 204
  end

  private
  def set_shop
    # includes 是 Rails 提供的一种预加载（eager loading）方法，用于解决 N+1 查询问题。
    # 这里的意思是：在查询 Shop 的同时，预加载与之关联的 User 数据。
    @shop = Shop.includes(:user).find_by_id params[:id]
  end

  def serializer_shop(shop, error_code = 0, message = 'ok', option = {})
    options = { include: [:user] }
    options = options.merge(option)
    shop_hash = ShopSerializer.new(shop, options).serializable_hash
    shop_hash['error_code'] = error_code
    shop_hash['message'] = message
    shop_hash
  end

  # def set_response_data shop
  #   # 在 Ruby 中，方法名末尾的 ? 是一种命名约定，表示该方法返回一个布尔值（true 或 false）
  #   # shop不存在返回一个空哈希{}
  #   return {} unless shop.present?
  #   {
  #     id: shop.id,
  #     name: shop.name,
  #     products_count: shop.products_count,
  #     orders_count: shop.orders_count,
  #     created_at: shop.created_at,
  #     owner: {
  #       id: shop.user_id,
  #       email: shop.user.email
  #     }
  #   }
  # end

  def shop_params
    params.require(:shop).permit(:name, :products_count, :orders_count)
  end

  def check_login
    head 401 unless current_user
  end

  def check_owner
    head 403 unless current_user&.id == @shop.user.id
  end
end
