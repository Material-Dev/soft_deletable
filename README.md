# SoftDeletable

Soft deleting is a relatively common pattern which lets you hide records instead of deleting them. It can be configured on a per-model level. It works with models using both ActiveRecord and MongoId ORMs

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'soft_deletable', git: 'https://github.com/Material-Dev/soft_deletable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install soft_deletable --source https://github.com/Material-Dev/soft_deletable

## Usage

SoftDelete works by setting `soft_deleted_at` to Time.now.  Make sure your model has a datetime `soft_deleted_at` column.  And include the module into your active_record class:

```ruby
class User < ApplicationRecord
  include SoftDeletable

  ...
end
```

`myModel.soft_delete!` sets `soft_deleted_at: Time.now` and returns `myModel`.

You can also pass an optional block of code as argument to do something little extra after the record is soft deleted. For example this can be useful if you want to remove a record form elastic search index once it is soft deleted.

Exa:

```ruby
myModel.soft_delete! { ElasticSearch.remove_index(self) }
```

## Default Scope

By default, SoftDeletable uses a default_scope. There is a exclude_soft_deleted scope which is same as default scope.
To query soft deleted records we also have a scope named soft_deleted.

## SoftDeletable Restorable

You can also restore soft deleted records using

`myModel.restore_soft_delete`

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Material-Dev/soft_deletable.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).