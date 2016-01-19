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
    joins("INNER JOIN (#{Spree::SalePrice.active.to_sql}) sale_prices ON #{Spree::Price.table_name}.id = sale_prices.price_id")
    # joins(:prices, :sale_prices).merge(Spree::SalePrice.active)
    # joins("INNER JOIN (
    #           #{Spree::Variant.joins(:prices, :sale_prices).merge(Spree::SalePrice.active).to_sql}
    #         )
    #         as sale_variants ON #{Spree::Product.table_name}.id = sale_variants.product_id")
  end

  add_search_scope :ascend_by_master_price do
    scope = Spree::Product.sale_price_arel
    joins(:master => :default_price).
        joins("LEFT JOIN (#{scope.to_sql}) AS m_price ON m_price.id = #{Spree::Price.table_name}.id")
        .order("m_price.merge_case ASC")
  end

  add_search_scope :descend_by_master_price do
    scope = Spree::Product.sale_price_arel
    joins(:master => :default_price).
        joins("LEFT JOIN (#{scope.to_sql}) AS m_price ON m_price.id = #{Spree::Price.table_name}.id")
        .order("m_price.merge_case DESC")
  end

  # add sorting scope

  private

  def run_on_variants(all_variants, &block)
    if all_variants && variants.present?
      variants.each { |v| block.call v }
    end
    block.call master
  end

  def self.sale_price_arel
    price = Spree::Price.arel_table
    sale_price = Spree::SalePrice.arel_table
    sale_price = sale_price.where(sale_price[:enabled].eq(true)).where(sale_price[:start_at].lteq(Time.now).or(sale_price[:start_at].eq(nil))).project('*').as('sale_price_join')
    merge_case = Arel::Nodes::SqlLiteral.new("CASE WHEN value IS NULL THEN amount ELSE value END")
    return price.join(sale_price, Arel::Nodes::OuterJoin).on(price[:id].eq(sale_price[:price_id])).project(merge_case.as('merge_case')).project(price[:id].as('id'))
  end
end
