require 'minitest_helper'
require 'stringio'
require 'yaml'
require 'byebug'

class TestPreserveYaml < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PreserveYaml::VERSION
  end

  def test_preserves_anchors_on_hashes
    input = load_example 'anchors'
    preserve_yaml(input) do |data|
      data['hash']['a'] = 55
      data['int'] += 3
      data['str'] = data['str'].upcase
    end

    input.rewind
    assert_valid_yaml input
    assert_equal load_result('anchors'), input.read
  end

  def test_preserves_merges
    skip :pending
  end
  
  private

  def assert_valid_yaml(io)
    text = io.read
    YAML.load(text)
    pass
  rescue StandardError
    flunk "Not valid YAML: #{text}"
  ensure
    io.rewind
  end

  def load_example(name)
    StringIO.new(File.read(File.join(example_root, "#{name}.yml")))
  end

  def load_result(name)
    File.read(File.join(example_root, "#{name}_out.yml"))
  end

  def example_root
    File.expand_path('../examples', __FILE__)
  end


end
