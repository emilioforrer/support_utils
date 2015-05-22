module SupportUtils
  class SubscriberTest < SupportUtils::PubSub::Subscribers::Base

    def test_event(event)
      event.payload[:data][:changed] = "Added a new key"
    end

  end
end
