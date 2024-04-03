require 'minitest/autorun'
require 'with_model'
require 'mocha/minitest'
require 'byebug'
require_relative '../lib/soft_deletable.rb'

WithModel.runner = :minitest
class Minitest::Spec
  extend WithModel
end
