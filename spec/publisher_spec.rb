module SupportUtils
  class PublisherTest < SupportUtils::PubSub::Publishers::Base
    self.pub_sub_namespace = 'support_utils_test'
  end
end
