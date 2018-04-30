class Polygon

  attr_reader :a
  attr_reader :b
  attr_reader :c
  attr_reader :material_index

  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c

    @siblings = []

    @material_index = 0
  end

  def add_sibling(sibling_index)
    @siblings.push(sibling_index)
  end

  def sibling(index)
    sibling = -1
    if @siblings.length > index
      sibling = @siblings[index]
    end
    sibling
  end

end