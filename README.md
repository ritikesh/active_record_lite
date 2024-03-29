# ActiveRecordLite
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/ritikesh/active_record_lite/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/ritikesh/active_record_lite/tree/master)
[![Gem Version](https://badge.fury.io/rb/active_record_lite.svg)](https://badge.fury.io/rb/active_record_lite)

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

For specific use-cases, you can also limit loading the number of columns by passing the selectable columns to `to_lite`.

```ruby
    class User < ActiveRecord::Base
        has_lite, columns: %w(id name email)
    end

    @user = User.where(id: 1).to_lite(:id, :name) # select id, name from users where id = 1;
    @user.id # => 1
    @user.name # => "name"

    @user.email # => nil
```

#### NOTE:
1. active_record_lite internally uses active_record, hence model level default scopes will apply when querying for the record from db.

2. `to_lite` should be called after all `serialize` calls in the model. `to_lite` relies on `serialised_attributes` which will be correctly initialised only after all the `serialize` calls.

#### TODO:
1. Add support to eager load lite objects via AR relation.currently.

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ritikesh/active_record_lite. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveRecordLite project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/active_record_lite/blob/master/CODE_OF_CONDUCT.md).
