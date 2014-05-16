require "mongoid_retry/version"

module Mongoid
  module MongoidRetry

    DUPLICATE_KEY_ERROR_CODES = [11000,11001]
    MAX_RETRIES = 3

    if Mongoid::VERSION < '3'
      def self.error_message(exception)
        exception.message
      end

      def self.error_code(exception)
        exception.error_code
      end
    else
      def self.error_message(exception)
        exception.details["err"]
      end

      def self.error_code(exception)
        exception.details["code"]
      end
    end

    def self.is_a_duplicate_key_error?(exception)
      DUPLICATE_KEY_ERROR_CODES.include?(error_code(exception))
    end

    # Catch a duplicate key error
    def save_and_retry(options = {})
      if ::Mongoid::VERSION < '3'
        begin
          safely.save!
        rescue Mongo::OperationFailure => e
          retry_if_duplicate_key_error(e, options)
        end
      else
        begin
          with(safe: true).save!
        rescue Moped::Errors::OperationFailure => e
          retry_if_duplicate_key_error(e, options)
        end
      end
    end

    def retry_if_duplicate_key_error(e, options)
      retries = options.fetch(:retries, MAX_RETRIES)
      if ::Mongoid::MongoidRetry.is_a_duplicate_key_error?(e) && retries > 0
        keys = duplicate_key(e)
        if (duplicate = find_duplicate(keys))
          if options[:allow_delete]
            duplicate.delete
            save_and_retry(options)
          else
            update_document!(duplicate, options.merge(retries: retries - 1))
          end
        end
      else
        raise e
      end
    end

    private

    def find_duplicate(keys)
      self.class.where(keys).first
    end

    def duplicate_key(exception)
      index = ::Mongoid::MongoidRetry.error_message(exception)[/(?<=\.\$)\w*/,0]
      fields = index.split(/\d/).map{|s| s.gsub(/^_|_-?$/,'')}
      fields.inject({}) {|hash, key| hash[key] = send(key) if respond_to?(key); hash}
    end

    def update_document!(duplicate, options = {})
      attributes.except("_id").each_pair do |key, value|
        duplicate[key] = value
      end
      duplicate.save_and_retry(options)
    end

  end
end
