module FifthColumn
  module UtilMethods
    def caching_method_names(method)
      washed_method = method.to_s.sub(/([?!=])$/, '')
      punctuation = $1
      ["#{washed_method}_without_db_value_caching#{punctuation}",
       "#{washed_method}_with_db_value_caching#{punctuation}"]
    end

    def cache_column(method)
      "#{method}_cache".to_sym
    end

    def logger
      RAILS_DEFAULT_LOGGER
    end
  end
  
  class Util
    extend UtilMethods
  end

end
