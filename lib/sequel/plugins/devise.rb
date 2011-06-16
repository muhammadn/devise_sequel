require 'devise_sequel'

module Sequel
  module Plugins
    module Devise

      def self.apply (model, *args)
        model.plugin :active_model
        model.plugin :hook_class_methods
        model.extend ::Devise::Models
      end

      def self.configure (model, *args)
        model.devise(*args) unless args.empty?
      end

      module ClassMethods

        # for some reason devise tests still use create! from the model itself
        def create! (*args)
          # to_adapter.create!(*args)
          o = new(*args)
          raise unless o.save
          o
        end

      end # ClassMethods
      
      module InstanceMethods

        def changed?
          modified?
        end

        def save!
          save(:raise_on_failure => true)
        end

        def update_attributes (*args)
          update(*args)
        end

        def attributes= (hash, guarded=true)
          (guarded) ? set(hash) : set_all(hash)
        end

      end # InstanceMethods
    end # Devise
  end
end
