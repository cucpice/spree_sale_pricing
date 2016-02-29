Spree::Core::ProductFilters.module_eval do
  #try to eval search scope into ProductFilters
  #this is untested TODO:- TEST


  # For product price in any specified range
  Spree::Product.add_search_scope :price_range do |*opts|
    v = Spree::Price.arel_table
    a = Spree::SalePrice.arel_table.alias
    if opts.count != 2
      # scope = v
      Spree::Product.joins(master: :default_price)
    else
      conds = opts.map{|t| t.to_i}.sort
      # scope = v[:amount].in(conds.first..conds.last)
      scope1 = a[:value].in(conds.first..conds.last)
      scope2 = v[:amount].in(conds.first..conds.last).and(a[:value].eq(nil))
      puts "scope = #{opts}"
      Spree::Product.joins(master: :default_price)
          .joins("LEFT JOIN #{a.to_sql} ON #{v[:id].eq(a[:price_id]).to_sql}")
          .where("#{scope1.to_sql} OR (#{scope2.to_sql})")
    end
  end
end

