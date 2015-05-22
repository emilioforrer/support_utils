module SupportUtils
  module Concerns
    module PubSub
      module Subscriber
        extend ::ActiveSupport::Concern


        included do
          class_attribute :subscriptions_enabled
          attr_reader :namespace
        end

        def initialize(namespace)
          @namespace = namespace
        end

        # trigger methods when an event is captured
        def call(message, *args)
          method  = message.gsub("#{namespace}.", '')
          handler = self.class.new(namespace)
          handler.send(method, ActiveSupport::Notifications::Event.new(message, *args))
        end


        module ClassMethods
          # attach public methods of subscriber with events in the namespace
          def subscribe_to(namespace)
            log_subscriber = new(namespace)
            log_subscriber.public_methods(false).each do |event|
              ActiveSupport::Notifications.subscribe("#{namespace}.#{event}", log_subscriber)
            end
          end
        end

      end
    end
  end
end
