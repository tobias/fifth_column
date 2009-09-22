module FifthColumn
  module Util
    def caching_method_names(method)
      washed_method = method.to_s.sub(/([?!=])$/, '')
      punctuation = $1
      ["#{washed_method}_without_db_value_caching#{punctuation}",
       "#{washed_method}_with_db_value_caching#{punctuation}"]
    end

    def cache_column(method)
      "#{method}_cache".to_sym
    end
  end
end
