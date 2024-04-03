Gem::Specification.new do |spec|
  spec.name           = "soft_deletable"
  spec.version        = "0.1.0"
  spec.authors        = ["harsh-materialplusio"]
  spec.email          = ["harshwardhan.rathore@materialplus.io"]
  spec.summary        = %q{Module to implement soft delete}
  spec.description    = %q{The gem provides functionality to implement soft delete per record basis supporting both ActiveRecord and MongoId ORMs.}
  spec.homepage       = "https://github.com/Material-Dev/soft_deletable"
  spec.license        = "MIT"

  spec.files          = Dir['{lib}/**/*'] + ['README.md', 'LICENSE.txt']
  spec.add_dependency 'activerecord'
  spec.add_dependency 'mongoid'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'with_model'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'byebug'
end