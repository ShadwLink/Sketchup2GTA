require 'test/unit'
require './src/shadowlink_iv_exporter/mip_map_level_calculator'

class TextureExporterTest < Test::Unit::TestCase

  def test_128_should_be_6
    @mipmap_calculator = MipMapLevelCalculator.new
    mipmap_count = @mipmap_calculator.calculate_mipmap_count(128, 128)
    assert_equal(6, mipmap_count)
  end

  def test_64_should_be_5
    @mipmap_calculator = MipMapLevelCalculator.new
    mipmap_count = @mipmap_calculator.calculate_mipmap_count(64, 64)
    assert_equal(5, mipmap_count)
  end

  def test_should_take_lowest_dimension_to_calculate_mipmap_count
    @mipmap_calculator = MipMapLevelCalculator.new
    mipmap_count = @mipmap_calculator.calculate_mipmap_count(256, 128)
    assert_equal(6, mipmap_count)
  end

  def test_should_raise_an_exception_because_width_is_invalid
    @mipmap_calculator = MipMapLevelCalculator.new

    assert_raise ArgumentError do
      @mipmap_calculator.calculate_mipmap_count(127, 128)
    end
  end

  def test_should_raise_an_exception_because_height_is_invalid
    @mipmap_calculator = MipMapLevelCalculator.new

    assert_raise ArgumentError do
      @mipmap_calculator.calculate_mipmap_count(256, 89)
    end
  end

end