class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    orders = current_user.orders
                         .page(params[:page] ? params[:page][:number] : 1)
                         .per_page(params[:page] ? params[:page][:size] : 10)
    render json: orders, meta: { pagination: pagination_meta(orders) }
  end

  def show
    respond_with current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.build
    order.build_placements_with_product_ids_and_quantities(params[:order][:product_ids_and_quantities])

    if order.save
      order.reload
      OrderMailer.delay.send_confirmation(order)
      render json: order, status: 201, location: [:api, current_user, order]
    end
  end

  private

  def order_params
    params.require(:order).permit(product_ids: [])
  end
end
