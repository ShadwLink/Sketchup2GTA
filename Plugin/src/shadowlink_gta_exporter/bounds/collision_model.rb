require 'shadowlink_gta_exporter/bounds/vertex'
require 'shadowlink_gta_exporter/bounds/polygon'
require 'shadowlink_gta_exporter/bounds/material_color'

class CollisionModel

  attr_reader :vertices
  attr_reader :polygons
  attr_reader :materials
  attr_reader :material_colors

  def initialize(ent)
    @vertices = []
    @polygons = []
    @materials = [1]
    @material_colors = []
    @material_colors.push(MaterialColor.new())

    faces = ent.definition.entities.find_all {|e| e.typename == "Face"}
    faces.each do |face|
      mesh = face.mesh 5
      points = mesh.points
      puts "points: #{points.length}"
      points.each do |point|
        vertex = Vertex.new(point)
        unless @vertices.index vertex
          @vertices.push(vertex)
        end
      end

      polygons = mesh.polygons
      polygons.each do |polygon|
        a = get_index_for_vertex(Vertex.new(mesh.points[polygon[0].abs - 1]))
        b = get_index_for_vertex(Vertex.new(mesh.points[polygon[1].abs - 1]))
        c = get_index_for_vertex(Vertex.new(mesh.points[polygon[2].abs - 1]))
        puts "polygon: #{polygon.length} [#{polygon[0].abs}][#{polygon[1].abs}][#{polygon[2].abs}] - [#{a}][#{b}][#{c}]"
        @polygons.push(Polygon.new(a, b, c))
      end

      @polygons.each do |polygon|
        polygon.add_sibling find_sibling(polygon, polygon.a, polygon.b)
        polygon.add_sibling find_sibling(polygon, polygon.b, polygon.c)
        polygon.add_sibling find_sibling(polygon, polygon.c, polygon.a)
        puts "siblings #{polygon.sibling(0)} #{polygon.sibling(1)} #{polygon.sibling(2)}"
      end

      @bounds = Bounds.new(ent)
      scaleX = (@bounds.maxX - @bounds.minX) / 65536.0
      scaleY = (@bounds.maxY - @bounds.minY) / 65536.0
      scaleY = (@bounds.maxZ - @bounds.minZ) / 65536.0

    end
  end

  def get_index_for_vertex(vertex)
    @vertices.index vertex
  end

  def find_sibling(polygon, polygon_a, polygon_b)
    sibling_index = -1
    @polygons.each_with_index do |other_polygon, index|
      if other_polygon != polygon
        if other_polygon.is_sibling(polygon_a, polygon_b)
          sibling_index = index
        end
      end
    end
    sibling_index
  end

end