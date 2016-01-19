module Spree
  module Admin
    class SalePricesController < BaseController
      before_filter :load_product_and_variant
      after_filter :update_product, only: [:create, :destroy]
      respond_to :js, :html

      def index
        @sale_price = Spree::SalePrice.new
        @sale_prices = @variant.sale_price_in(@currency)
      end

      def show
        redirect_to action: :edit
      end

      def edit
        @sale_price = Spree::SalePrice.find(params[:id])
      end

      def update
        @sale_price = Spree::SalePrice.find(params[:id])
        @sale_price.update sale_price_params.except(:id)
        # flash[:success] = flash_message_for(@sale_price, :successfully_updated)
        redirect_to action: :index
      end

      # Create a new sale price
      def create
        @sale_price = @variant.put_on_sale(sale_price_params[:value], start_at: sale_price_params[:start_at], end_at: sale_price_params[:end_at])
        logger.debug @sale_price.inspect
        respond_with(@sale_price)
      end

      # Destroy a sale price
      def destroy
        @sale_price = Spree::SalePrice.find(params[:id])
        @sale_price.destroy

        respond_with(@sale_price)
      end

      private

      # Load the variant as a before filter. Redirect to the referer if no product is found
      def load_product_and_variant
        @product = Spree::Product.find_by(slug: params[:product_id])
        if params.has_key?(:variant_id)
          @variant = @product.variants_including_master.find(params[:variant_id])
        else
          @variant = @product.master
        end
        @currency = Spree::Config[:currency] || 'USD'
        redirect_to request.referer unless @variant
      end

      # Sale price params
      def sale_price_params
        p = params.require(:sale_price).permit(:id, :value, :start_at, :end_at, :enabled)
        #  normalize param
        p[:start_at] = Time.zone.parse(p[:start_at])
        p[:end_at] = Time.zone.parse(p[:end_at])
        p
      end

      def update_product
        @product.touch
      end

      # TODO:- date time format to be inherit from spree
      def date_time_format
        Spree::t(:rb_format, scope: 'date_time_picker', default: '%Y/%m/%d %H:%M')
      end

    end
  end
end
