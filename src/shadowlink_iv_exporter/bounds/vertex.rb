class Vertex

  attr_reader :r
  attr_reader :g
  attr_reader :b
  attr_reader :a

  def initialize(point)
    @x = point[0]
    @y = point[1]
    @z = point[2]

    @r = 255
    @g = 255
    @b = 255
    @a = 255
  end

  def x
    @x * 0.0254 * GetScale()
  end

  def y
    @y * 0.0254 * GetScale()
  end

  def z
    @z * 0.0254 * GetScale()
  end

  def ==(another_vertex)
    self.x == another_vertex.x and self.y == another_vertex.y and self.z == another_vertex.z
  end
end