# Deface::Override.new({
#   virtual_path: "spree/admin/variants/index",
#   name: "add_sale_prices_button_to_variants_index",
#   insert_before: "td.actions",
#   text: '<%= link_to_with_icon("usd", "", admin_variant_sale_prices_path(@variant), { no_text: true )} %>',
#   original: '856e87261a419d5b5bc0a734f2ec481c4c2fe0f7',
#   disabled: false
# })

# Deface::Override.new({
#   :virtual_path => "spree/admin/variants/index",
#   :name => "add_msrp_to_variant_index_header",
#   :replace_contents => "[data-hook='variants_header']",
#   :partial => "spree/admin/variants/variants_header"
# })
#
# Deface::Override.new({
#   :virtual_path => "spree/admin/variants/index",
#   :name => "add_msrp_to_variant_index_row",
#   :replace_contents => "[data-hook='variants_row']",
#   :partial => "spree/admin/variants/variants_row"
# })


# Deface::Override.new({
#   virtual_path: "spree/admin/products/_form",
#   name: "add_on_sale_to_product_form",
#   insert_bottom: "[data-hook='admin_product_form_price']",
#   text: '<% if @product.on_sale? %><strong><%= "(On sale for #{@product.display_price})" %></strong><% end %>',
#   disabled: false
# })

# Deface::Override.new({
#   virtual_path: "spree/admin/variants/_form",
#   name: "add_on_sale_to_variant_form",
#   insert_bottom: "[data-hook='price']",
#   text: '<% if @variant.on_sale? %><strong><%= "(On sale for #{@variant.display_price})" %></strong><% end %>',
#   disabled: false
# })

Deface::Override.new({
  virtual_path: "spree/admin/products/new",
  name: "add_msrp_to_new_product",
  replace_contents: "[data-hook='new_product_attrs']",
  partial: "spree/admin/products/new_product_attrs",
  disabled: false
})

# Deface::Override.new({
#   :virtual_path => "spree/admin/variants/_form",
#   :name => "add_msrp_to_variant_form",
#   :insert_after => "[data-hook='sku']",
#   :partial => "spree/admin/variants/variant_msrp_field"
# })
