require "minitest/autorun"
require "cteng/extension"

class ExtensionTest < MiniTest::Unit::TestCase
  def test_load_non_existant_folder
    assert_raises(RuntimeError) { Extension.loadFolder('does_no_exist') }
  end

  def test_load_folder
    folder = File.dirname(__FILE__) + '/../fixtures/extensions'
    extensions = Extension.loadFolder(folder)

    assert_equal 2, extensions.length
    assert_equal 2, extensions[0].translations['default'].length
    assert_equal 2, extensions[1].translations['default'].length
  end
end
