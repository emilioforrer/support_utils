module SupportUtils
  module Concerns
    module Utils
      extend ActiveSupport::Concern

      included do
        if ActiveRecord::Base.connection.table_exists?(self.table_name)
          self.columns_hash.each do |column_name, metadata|
            self.class_eval <<-RUBY

              case
              when  [:date, :datetime, :time, :timestamp].include?(metadata.type.to_s.to_sym)

                def #{column_name}_format format = :default, *args
                  options = args.extract_options!
                  settings = HashWithIndifferentAccess.new({
                    format: format
                  }).deep_merge(options)
                  I18n.l(self.#{column_name}, settings) if #{column_name}
                end

              when metadata.type == :integer

                if metadata.limit.to_i == 1
                  def #{column_name}? *args
                    self.#{column_name}.to_i.eql?(1)
                  end
                end

              when [:float, :decimal].include?(metadata.type.to_s.to_sym)

                def #{column_name}_format *args
                  options = args.extract_options!
                  settings = HashWithIndifferentAccess.new({
                    precision: 2
                    }).deep_merge(options)
                  if settings[:currency].present?
                    utils.h.number_to_currency self.#{column_name}, *[settings]
                  else
                    utils.h.number_with_precision self.#{column_name}, *[settings]
                  end
                end

              when [:string, :text].include?(metadata.type.to_s.to_sym)

                  def #{column_name}_format *args, &block
                    options = args.extract_options!
                    case
                    when options[:truncate].present?

                      opts = options[:truncate].is_a?(Hash) ? options[:truncate] : {}
                      utils.h.truncate self.#{column_name}.to_s, opts, &block

                    when options[:word_wrap].present?

                      opts = options[:word_wrap].is_a?(Hash) ? options[:word_wrap] : {}
                      utils.h.word_wrap self.#{column_name}.to_s, opts, &block

                    when options[:highlight].present?
                      opts = options[:highlight].is_a?(Hash) ? options[:highlight] : {}
                      phrases = (opts[:phrases].is_a?(Regexp) || opts[:phrases].is_a?(String) || opts[:phrases].is_a?(Array)) ? opts[:phrases] : ""
                      utils.h.highlight self.#{column_name}.to_s,phrases, *opts.except(:phrases), &block

                    when options[:excerpt].present?
                      opts = options[:excerpt].is_a?(Hash) ? options[:excerpt] : {}
                      phrase = (opts[:phrase].is_a?(Regexp) || opts[:phrase].is_a?(String) ) ? opts[:phrase] : ""
                      utils.h.excerpt(self.#{column_name}.to_s,phrase, opts.except(:phrase), &block).to_s

                    else
                      html_options = options[:html_options] || {}
                      utils.h.simple_format(self.#{column_name}, html_options.except(:html_options), options).to_s
                    end
                  end

              else

                def #{column_name}_format *args
                  self.#{column_name}
                end

              end

            RUBY
          end
        end


      end

      def update_attributes(attributes)
        @saved = super
      end

      def save(*)
        @saved = super
      end

      def saved?
        @saved
      end


      def utils
        @utils ||= SupportUtils::Core::ActiveRecord::Utils.new(self)
      end


      module ClassMethods

        def truncate! confirm = false
          adapter = ActiveRecord::Base.configurations[Rails.env]["adapter"]
          adapter_method = :"truncate_#{adapter}!"
          if confirm
            if respond_to?(adapter_method, true)
              send(adapter_method)
            else
              ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name.to_s}")
            end
          end
        end

        private

        # SQLite doesn't have the "TRUNCATE TABLE" command
        def truncate_sqlite3!
          ActiveRecord::Base.connection.execute("DELETE FROM #{table_name.to_s}")
          ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='#{table_name.to_s}'")
        end

        # The "RESTART IDENTITY" Option will restart the primary key
        def truncate_postgresql!
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name.to_s} RESTART IDENTITY")
        end


      end

    end
  end
end
