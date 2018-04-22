class MipMapLevelCalculator

  def calculate_mipmap_count(width, height)
    unless is_power_of_two? width
      raise(ArgumentError, "width is not power of 2 (#{width})")
    end

    unless is_power_of_two? height
      raise(ArgumentError, "height is not power of 2 (#{height}")
    end

    mipmap_count = 1
    dimension = [width, height].min
    while dimension > 4
      dimension /= 2
      mipmap_count += 1
    end
    mipmap_count
  end

  def is_power_of_two?(num)
    num != 0 && (num & (num - 1)) == 0
  end

end