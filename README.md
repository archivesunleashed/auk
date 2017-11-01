# AUK; Archives Unleashed Cloud
[![Build Status](https://travis-ci.org/archivesunleashed/auk.svg?branch=master)](https://travis-ci.org/archivesunleashed/auk)
[![codecov](https://codecov.io/gh/archivesunleashed/auk/branch/master/graph/badge.svg)](https://codecov.io/gh/archivesunleashed/auk)
[![Gem Version](https://badge.fury.io/rb/auk.svg)](https://badge.fury.io/rb/auk)
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)
[![LICENSE](https://img.shields.io/badge/license-Apache-blue.svg?style=flat-square)](./LICENSE.txt)

![King Auk](https://thumbs.dreamstime.com/b/king-auks-92136782.jpg)

Rails application for the Archives Unleashed Cloud.

## Requirements

* [Ruby](https://www.ruby-lang.org/en/) 2.2 or later
* [Rails](http://rubyonrails.org) 5.1.2 or later

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'auk'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install auk
```

For further details, see our [Creating, installing, and running your Warclight application](https://github.com/archivesunleashed/auk/wiki/Creating%2C-installing%2C-and-running-your-Warclight-application) documentation.

### Run the test suite

Ensure Rails is _not_ running (ports 3000), then:

```sh
$ bundle exec rake
```

### Run a development server

```sh
$ bundle exec rake auk:server
```

Then visit http://localhost:3000.

### Run a console

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Release a new version of the gem

To release a new version:

1. Update the version number in `lib/auk/version.rb`
2. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, build the gem file (e.g., `gem build auk.gemspec`) and push the `.gem` file to [rubygems.org](https://rubygems.org) (e.g., `gem push auk-x.y.z.gem`).

## Contributing

Please see contributing guidelines @ [CONTRIBUTING.md](https://github.com/archivesunleashed/auk/blob/master/CONTRIBUTING.md) for details.
* [Bug reports](https://github.com/archivesunleashed/auk/issues)
* [Pull requests](https://github.com/archivesunleashed/auk/pulls) are welcome on AUK

## License

The gem is available as open source under the terms of the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

## Acknowledgments

This work is primarily supported by the [Andrew W. Mellon Foundation](https://uwaterloo.ca/arts/news/multidisciplinary-project-will-help-historians-unlock). Any opinions, findings, and conclusions or recommendations expressed are those of the researchers and do not necessarily reflect the views of the sponsors.
