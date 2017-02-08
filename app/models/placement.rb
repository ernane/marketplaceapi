class Placement < ActiveRecord::Base
  belongs_to :order, inverse_of: :placements
  belongs_to :product, inverse_of: :placements

  after_create :decrement_product_quantity!

  validates :quantity, presence: true

  def decrement_product_quantity!
    product.decrement!(:quantity, quantity)
  end
end
