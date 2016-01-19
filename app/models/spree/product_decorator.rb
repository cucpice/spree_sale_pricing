Spree::Product.class_eval do
  # Essentially all read values here are delegated to reading the value on the Master variant
  # All write values will write to all variants (including the Master) unless that method's all_variants parameter is set to false, in which case it will only write to the Master variant

  delegate_belongs_to :master, :active_sale_in, :current_sale_in, :next_active_sale_in, :next_current_sale_in,
                      :sale_price_in, :on_sale_in?, :original_price_in, :discount_percent_in, :sale_price,
                      :original_price, :on_sale?, :display_original_price, :display_sale_price


  # TODO also accept a class reference for calculator type instead of only a string
  def put_on_sale(value, all_variants = true, **options)
    run_on_variants(all_variants) { |v| v.put_on_sale(value, options) }
  end
  alias :create_sale :put_on_sale

  def enable_sale(all_variants = true)
    run_on_variants(all_variants) { |v| v.enable_sale }
  end

  def disable_sale(all_variants = true)
    run_on_variants(all_variants) { |v| v.disable_sale }
  end

  def start_sale(end_time = nil, all_variants = true)
    run_on_variants(all_variants) { |v| v.start_sale(end_time) }
  end

  def stop_sale(all_variants = true)
    run_on_variants(all_variants) { |v| v.stop_sale }
  end

  add_search_scope :on_sale_items do
    joins(:master => :default_price).
    joins("INNER JOIN #{Spree::SalePrice.table_name} ON #{Spree::Price.table_name}.id = #{Spree::SalePrice.table_name}.price_id")
    # joins(:prices, :sale_prices).merge(Spree::SalePrice.active)
    # joins("INNER JOIN (
    #           #{Spree::Variant.joins(:prices, :sale_prices).merge(Spree::SalePrice.active).to_sql}
    #         )
    #         as sale_variants ON #{Spree::Product.table_name}.id = sale_variants.product_id")
  end

  # add sorting scope

  private

  def run_on_variants(all_variants, &block)
    if all_variants && variants.present?
      variants.each { |v| block.call v }
    end
    block.call master
  end
end
