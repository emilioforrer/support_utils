module SupportUtils
  module PubSub
    module Publishers
      class Base
        include SupportUtils::Concerns::PubSub::Publisher
      end
    end
  end
end
