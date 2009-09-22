module FifthColumn

  class MissingCacheColumnException < StandardError
  end

  class CacheMachine
    class << self
      include UtilMethods
      
      def retrieve_and_cache_value(object, method, options)
        logger.debug "fifth_column: retrieving cached :#{method} from #{object.class.name}[#{object.id}]"
        without_method = caching_method_names(method).first
        cache_column = cache_column(method)
        check_for_db_cache_column(object, cache_column)
        value = object.read_attribute(cache_column)
        if value.nil?
          start = Time.now
          value = object.__send__(without_method)
          elapsed = Time.now - start
          object.write_attribute(cache_column, value)
          object.save false
          logger.info "fifth_column: cached :#{method} on #{object.class.name}[#{object.id}] (will save #{elapsed} seconds)"
        end
        value
      end

      def clear_cached_value(object, method, options)
        logger.info "fifth_column: clearing :#{method} on #{object.class.name}[#{object.id}]"
        options[:context] ||= DEFAULT_CONTEXT
        cache_column = cache_column(method)
        object.write_attribute(cache_column, nil)
        options = object.class.db_cached_values_for_context(options[:context])[method].merge(options)
        if options[:recalculate_on_clear]
          FifthColumn::CacheMachine.retrieve_and_cache_value(object, method, options)
        elsif object.__send__("#{cache_column}_changed?")
          object.save(false)
        end
      end
      
      private
      def check_for_db_cache_column(object, cache_column)
        raise FifthColumn::MissingCacheColumnException.new("object of class #{object.class.name} is missing cache column #{cache_column}") unless object.attribute_names.include?(cache_column.to_s)
      end
    end
  end
end
