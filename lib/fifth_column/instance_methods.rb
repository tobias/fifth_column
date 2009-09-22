module FifthColumn
  module InstanceMethods
    
    def clear_db_cached_value(method, options = { })
      FifthColumn::CacheMachine.clear_cached_value(self, method, options)
    end

    def clear_db_cached_values_in_context(context, options = { })
      options[:context] = context
      self.class.db_cached_values_for_context(context).each do |method, method_options|
        clear_db_cached_value(method, options)
      end
    end
  end
end
