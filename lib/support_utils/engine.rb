module SupportUtils
  class Engine < ::Rails::Engine
    isolate_namespace SupportUtils

    config.after_initialize do
      ActiveRecord::Base.send(:include, SupportUtils::Concerns::Core)
    end

    config.before_initialize do

    end

    config.to_prepare do
    end

  end
end
