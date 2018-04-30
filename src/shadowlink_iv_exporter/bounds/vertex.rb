class Vertex

  attr_reader :x
  attr_reader :y
  attr_reader :z

  attr_reader :r
  attr_reader :g
  attr_reader :b
  attr_reader :a

  def initialize(point)
    @x = point[0]
    @y = point[1]
    @z = point[2]

    @r = 0
    @g = 0
    @b = 0
    @a = 0
  end

  def ==(another_vertex)
    self.x == another_vertex.x and self.y == another_vertex.y and self.z == another_vertex.z
  end
end