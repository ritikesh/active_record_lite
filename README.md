# ActiveRecordLite

Lightweight ActiveRecord extension for basic reads and caching.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_lite'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_lite

## Usage

To start using lite models, inject `has_lite` in your model and append `.to_lite` to your `ActiveRecord` `scope` or `chained` method calls.

```ruby
    class User < ActiveRecord::Base
        has_lite
    end

    @user = User.where(id: 1).to_lite # <User::ActiveRecordLite... >
    @user.id # => 1
    @user.name # => "name"

    @users = User.where(tenant_id: 1).to_lite # [<User::ActiveRecordLite... >, ...]
    @users.first.id # => 1
    @users[-1].id # => 100
```

By default the lite class will include all columns defined in the parent model class. To limit to specific columns, pass the columns key to the `has_lite` call.

```ruby
    class User < ActiveRecord::Base
        has_lite, columns: %w(id name)
    end

    @user = User.where(id: 1).to_lite
    @user.id # => 1
    @user.name # => "name"

    @user.email # => undefined method
```

#### NOTE:
1. To keep the gem lightweight, `serialization` is the implementer's job. Eg.
```ruby
    class User < ActiveRecord::Base
        has_lite, columns: %w(id name preferences)

        serialize :preferences, Hash
    end
    
    # to serialize preferences in lite model
    class User::ActiveRecordLite < ActiveRecordLite::Base
        def preferences
            YAML.load(read_attribute('preferences'.freeze))
        end
    end
```
2. active_record_lite internally uses active_record, hence model level default scopes will apply when querying for the record from db.

3. `Boolean` columns in rails are very smaller integers - literally, `TINYINT`. Internally, `ActiveRecord` magic typecasts them to behave like bools and adds the `column_name?` methods to the model. This is also left to the implementer.
```ruby
    class Company::ActiveRecordLite < ActiveRecordLite::Base
        def active
            read_attribute('active'.freeze) == 1
        end
        alias :active? :active
    end
```
#### TODO:
1. Dynamic selects are not possible currently.

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ritikesh/active_record_lite. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveRecordLite project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/active_record_lite/blob/master/CODE_OF_CONDUCT.md).
