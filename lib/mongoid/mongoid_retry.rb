require "mongoid_retry/version"

module Mongoid
  module MongoidRetry

    DUPLICATE_KEY_ERROR_CODES = [11000,11001]

    # Catch a duplicate key error
    def save!
      begin
        super
      rescue Mongo::OperationFailure => e
        if is_a_duplicate_key_error?(e)
          keys = duplicate_key(e)
          if (duplicate = find_duplicate(keys))
            update_document!(duplicate)
          end
        else
          raise e
        end
      end
    end

    private

    def is_a_duplicate_key_error?(exception)
      DUPLICATE_KEY_ERROR_CODES.include?(exception.error_code)
    end

    def find_duplicate(keys)
      find(conditions: keys)
    end

    def duplicate_key(exception)
      index = exception.message[/(?<=\.\$)\w*/,0]
      fields = index.split(/\d/).map{|s| s.gsub(/^_|_-?$/,'')}
      fields.inject({}) {|hash, key| hash[key] = send(key); hash}
    end

    def update_document!(duplicate)
      attributes.each_pair do |key, value|
        duplicate[key] = value
      end
      duplicate.save!
    end

  end
end
