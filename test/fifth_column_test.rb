require 'test_helper'

class TestClass
  include FifthColumn::InstanceMethods
  extend FifthColumn::ClassMethods

  def calc_some_value
  end

end
  
class FifthColumnTest < Test::Unit::TestCase
  context 'specifying value to cache' do
    setup do
      TestClass.send(:db_cache_value, :calc_some_value => {:context => :test })
    end

    context 'storing options' do
      
      should 'store an entry for the cached value in the default context' do
        TestClass.db_cached_values_for_context[:calc_some_value].should_not == nil
      end
      
      should 'store an entry for the cached value in the :test context' do
        TestClass.db_cached_values_for_context(:test)[:calc_some_value].should_not == nil
      end
      
    end

    context 'aliasing value method' do
      teardown do
        TestClass.send(:remove_method, :calc_some_value_cache=) if TestClass.instance_methods.include?('calc_some_value_cache=')
      end
      context 'when the cache column exists' do
        setup do
          TestClass.send(:define_method, :calc_some_value_cache=, Proc.new { } )
        end

        should 'alias the value method' do
          TestClass.instance_methods.include?('calc_some_value_with_db_value_caching').should == true
        end
      end
    end
    
  end
  
  context 'clearing values' do
    context 'on an instance' do
      should 'test this'
    end
  end

end
