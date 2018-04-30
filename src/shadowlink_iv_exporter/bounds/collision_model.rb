require 'shadowlink_iv_exporter/bounds/vertex'
require 'shadowlink_iv_exporter/bounds/polygon'

class CollisionModel

  attr_reader :vertices
  attr_reader :polygons

  def initialize(ent)
    @vertices = []
    @polygons = []

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

    end
  end

  def get_index_for_vertex(vertex)
    @vertices.index vertex
  end

end