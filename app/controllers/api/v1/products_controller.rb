class Api::V1::ProductsController < ApiController
  before_action :set_product, only: %i[show update destroy]

  def index
    @products = Product.page(current_page).per_page(per_page)
    options = get_links_serializer_options 'api_v1_products_path', @products
    render json: serializer_product(@products, 0, 'ok', options), status: :ok
  end

  def show
    render json: serializer_product(@product), status: :ok
  end

  def create
    # todo
  end

  def update
    # pass
  end

  def destroy
    # todo
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
end
