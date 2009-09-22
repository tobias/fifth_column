require 'active_record'
require 'fifth_column/util'
require 'fifth_column/cache_machine'
require 'fifth_column/instance_methods'
require 'fifth_column/class_methods'

ActiveRecord::Base.__send__(:include, FifthColumn::InstanceMethods)
ActiveRecord::Base.__send__(:extend, FifthColumn::ClassMethods)
