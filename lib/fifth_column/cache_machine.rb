module FifthColumn
  class CacheMachine
    include Util

    class << self
      def retrieve_and_cache_value(object, method, options)
        without_method = caching_method_names(method).first
        cache_column = cache_column(method)
        value = object.read_attribute(cache_column)
        if value.nil?
          value = object.__send__(without_method)
          object.write_attribute(cache_column, value)
          object.save false
        end
        value
      end
    end
  end
end
