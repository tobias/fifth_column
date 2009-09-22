module FifthColumn
  module InstanceMethods
    include Util
    
    def clear_db_cached_value(method, options)
      write_attribute(cache_column(method), nil)
      if options[:recalculate_on_clear]
        FifthColumn::CacheMachine.retrieve_and_cache_value(self, method, options)
      else
        save false
      end
      
    end
  end
end
