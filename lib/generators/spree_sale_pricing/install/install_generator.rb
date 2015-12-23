module SpreeSalePricing
  module Generators
    class InstallGenerator < Rails::Generators::Base

      def add_javascripts
        if File.exists? "#{Rails.root}/vendor/assets/javascripts/spree/backend/all.js"
          inject_into_file "vendor/assets/javascripts/spree/backend/all.js", before: "//= require_tree" do
            result =  "//= require spree/backend/spree_sale_pricing\n"
          end
        end
        if File.exists? "#{Rails.root}/vendor/assets/javascripts/spree/frontend/all.js"
          inject_into_file "vendor/assets/javascripts/spree/frontend/all.js", before: "//= require_tree" do
            result =  "//= require spree/frontend/spree_sale_pricing\n"
          end
        end
      end

      def add_stylesheets
        inject_into_file "vendor/assets/stylesheets/spree/frontend/all.css", " *= require spree/frontend/spree_sale_pricing\n", :before => /\*\//, :verbose => true
        inject_into_file "vendor/assets/stylesheets/spree/backend/all.css", " *= require spree/backend/spree_sale_pricing\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_sale_pricing'
      end

      def run_migrations
         res = ask "Would you like to run the migrations now? [Y/n]"
         if res == "" || res.downcase == "y"
           run 'bundle exec rake db:migrate'
         else
           puts "Skiping rake db:migrate, don't forget to run it!"
         end
      end
    end
  end
end
