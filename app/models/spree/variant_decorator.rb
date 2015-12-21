Spree::Variant.class_eval do

  has_many :sale_prices, through: :prices

  delegate_belongs_to :default_price, :sale_price, :original_price, :on_sale?,
                      :display_original_price, :display_sale_price

  # TODO also accept a class reference for calculator type instead of only a string
  def put_on_sale(value, all_currencies = true, **options)
    run_on_prices(all_currencies) { |p| p.put_on_sale value, options }
  end
  alias :create_sale :put_on_sale

  # TODO make update_sale method

  def active_sale_in(currency)
    price_in(currency).active_sale
  end
  alias :current_sale_in :active_sale_in

  def next_active_sale_in(currency)
    price_in(currency).next_active_sale
  end
  alias :next_current_sale_in :next_active_sale_in

  def sale_price_in(currency)
    Spree::Price.new variant_id: self.id, currency: currency, amount: price_in(currency).sale_price
  end

  # Returns true if the product is discounted by an amount that rounds to at least 1%
  def discounted?
    begin
      price = self.price.respond_to?(:to_f) ? self.price.to_f : self.price.amount.to_f
      msrp = self.msrp.try(:to_f)

      msrp && self.price && ((1 - price / msrp) * 100).round > 0
    rescue
      false
    end
  end

  def discount_percent_in(currency)
    price_in(currency).discount_percent
  end

  # Returns a String with the discounted percentage between #price and #msrp.
  def display_discount
    if discounted?
      "#{((1 - price / msrp) * 100).round}"
    else
      '0'
    end
  end

  def on_sale_in?(currency)
    price_in(currency).on_sale?
  end

  def original_price_in(currency)
    Spree::Price.new variant_id: self.id, currency: currency, amount: price_in(currency).original_price
  end

  def enable_sale(all_currencies = true)
    run_on_prices(all_currencies) { |p| p.enable_sale }
  end

  def disable_sale(all_currencies = true)
    run_on_prices(all_currencies) { |p| p.disable_sale }
  end

  def start_sale(end_time = nil, all_currencies = true)
    run_on_prices(all_currencies) { |p| p.start_sale end_time }
  end

  def stop_sale(all_currencies=true)
    run_on_prices(all_currencies) { |p| p.stop_sale }
  end

  private

  def run_on_prices(all_currencies, &block)
    if all_currencies && prices.present?
      prices.each { |p| block.call p }
    else
      block.call default_price
    end
  end
end
