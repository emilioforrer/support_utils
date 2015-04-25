module SupportUtils
  module Core
    module ActiveRecord
      class Utils

        attr_reader :model

        def initialize model
          raise ArgumentError, ":model must be a subclass of ActiveRecord::Base" unless model.class < ::ActiveRecord::Base
          @model = model
        end

        def time_zone
          Time.zone
        end

        def helpers
          ActionController::Base.helpers
        end

        alias_method :h, :helpers

        def parse_time time
          time_zone.parse(time) rescue nil
        end

      end
    end
  end
end
