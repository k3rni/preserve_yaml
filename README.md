# PreserveYaml

Source lifted from [these](http://stackoverflow.com/a/12964176) [two](http://stackoverflow.com/a/15343320)
Stackoverflow answers.

## Rewriting YAML (e.g. configuration) files while preserving anchors and merges

Note that currently anchors are preserved only on hashes, or in YAML nomenclature, maps. This might change in the future to include more types.

```ruby

File.open('foo.yml', 'rw') do |fp|
  preserve_yaml(fp)  do |contents|
    contents['foo']['bar'] = 'Lorem ipsum'
  end
end
```

Now, `foo.yml` is rewritten to include changes made inside the block, while preserving existing anchors and merges as much as possible.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'preserve_yaml'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install preserve_yaml

## Contributing

1. Fork it ( https://github.com/k3rni/preserve_yaml/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
