module SupportUtils
  module Concerns
    module Core
      extend ActiveSupport::Concern

      included do

      end

      module ClassMethods
        def has_utils *args
          options = args.extract_options!
          include SupportUtils::Concerns::Utils
        end
      end

    end
  end
end
ActiveRecord::Base.send(:include, SupportUtils::Concerns::Core)
