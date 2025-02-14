class Api::V1::ProductsController < ApiController
  before_action :set_product, only: %i[show update destroy]
  before_action :check_owner, only: %i[show, update destroy]

  def index
    @products = Product.page(current_page).per_page(per_page)
    options = get_links_serializer_options 'api_v1_products_path', @products
    render json: serializer_product(@products, 0, 'ok', options), status: :ok
  end

  def show
    render json: serializer_product(@product), status: :ok
  end

  def create
    @product = current_user&.shop&.products&.build(product_params)
    if @product.save
      render json: serializer_product(@product), status: :created
    else
      render json: { error_code: 500, message: @product.errors }, status: 201
    end
  end

  def update
    if @product.update(product_params)
      render json: serializer_product(@product), status: 202
    else
      render json: { error_code: 500, message: @product.errors }, status: 202
    end
  end

  def destroy
    @product.destroy
    head 204
  end

  private

  def serializer_product(product, error_code = 0, message = 'ok', options = {})
    product_hash = ProductSerializer.new(product, options).serializable_hash
    product_hash['error_code'] = error_code
    product_hash['message'] = message
    product_hash
  end

  def set_product
    @product = Product.includes(:shop).find_by_id(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def check_owner
    head 403 unless current_user&.shop&.products&.exists?(id: params[:id])
  end
end
