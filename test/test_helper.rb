require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'matchy'
require 'pp'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'fifth_column'

class Test::Unit::TestCase
end
