module FifthColumn
  DEFAULT_CONTEXT  = :__ALL__
  
  module ClassMethods
    include Util
    
    def db_cached_values
      @@db_cached_values ||= { }
    end

    def db_cached_values_for_context(context = DEFAULT_CONTEXT)
      db_cached_values[context] ||= { }
    end
    
    def db_cache_value(options)
      options.each do |method, options|
        context = options.delete(:context)
        db_cached_values_for_context(DEFAULT_CONTEXT)[method] = options
        db_cached_values_for_context(context)[method] = options if context
        
        without_method, with_method = caching_method_names(method)
                                                           
        define_method with_method do
          FifthColumn::CacheMachine.retrieve_and_cache_value(self, method, options)
        end

        alias_method without_method, method
        alias_method method, with_method
      end
    end

    def clear_db_cached_values(options)
      context = options.delete(:context) || DEFAULT_CONTEXT
      conditions = options.delete(:conditions)
      find(:all, :conditions => conditions).each do |record|
        db_cached_values_for_context(context).keys.each do |value_method|
          record.clear_db_cached_value(value_method, options)
        end
      end
    end
  end
end
