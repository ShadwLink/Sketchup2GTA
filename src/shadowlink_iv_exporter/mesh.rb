class Mesh

  def initialize(faces)

    @vertices = []
    @uvs = []
    @normals = []
    @polygons = []

    @face_count = [0]

    current_vertex_count = 0

    faces.each do |face|
      mesh = face.mesh 5 # Create a trimesh of the face
      polys = mesh.polygons # Get all the polygons of this face
      points = mesh.points # Get all vertices of this mesh

      point_index = 1
      points.each do |point|
        @vertices.push(point)
        @uvs.push(mesh.uv_at(point_index, true))
        @normals.push(mesh.normal_at point_index)
        point_index += 1
      end

      polys.each do |poly|
        p1 = poly[0].abs - 1 + current_vertex_count
        p2 = poly[1].abs - 1 + current_vertex_count
        p3 = poly[2].abs - 1 + current_vertex_count

        @polygons.push(p1)
        @polygons.push(p2)
        @polygons.push(p3)
      end
      @face_count[0] += polys.length # Increase the facecount
      current_vertex_count += points.length
    end
  end

  def get_face_count
    @face_count[0] * 3
  end

  def polygons
    @polygons
  end

  def vertices
    @vertices
  end

  def normals
    @normals
  end

  def uvs
    @uvs
  end
end