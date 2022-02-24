class Polygon

  attr_reader :material_index

  def initialize(a, b, c)
    @vertices = [3]
    @vertices[0] = a
    @vertices[1] = b
    @vertices[2] = c

    @siblings = []

    @material_index = 0
  end

  def a
    @vertices[0]
  end

  def b
    @vertices[1]
  end

  def c
    @vertices[2]
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

  def is_sibling(a, b)
    @vertices.include? a and @vertices.include? b
  end

end