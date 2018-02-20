# CircleCI-TestReport

Create Test metadata for CircleCI

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'circleci-test_report'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install circleci-test_report

## Usage

```
% bundle exec rspec ./spec -f json -o rspec.json
% ruby -r 'circleci/test_report' -e "puts CircleCI::TestReport.create_xml(rspec_json: File.read('rspec.json'))" >> junit_format.xml
```

```ruby
require "circleci/test_report"

CircleCI::TestReport.create_xml(rspec_json: File.read('spec.json'))
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/circleci-test_report.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
