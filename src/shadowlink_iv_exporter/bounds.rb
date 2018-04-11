class Bounds

  def initialize(ent)
    calculate_bounds(get_vertices(ent))
  end

  def get_vertices(ent)
    vertices = []

    # purges all used faces and converts them to a list of vertices
    faces = ent.definition.entities.find_all {|e| e.typename == "Face"} # Get all face enteties
    faces.each do |face| # For each face
      mesh = face.mesh 5 # Create a trimesh of the face
      points = mesh.points # Get all vertices of this mesh
      points.each do |point| # For each vertex in this mesh
        unless vertices.index point # If it's not in the mesh
          vertices.push(point) # Add it to the vertex array
        end
      end
    end

    vertices
  end

  def calculate_bounds(vertices)
    calculate_bounding_box(vertices)
    calculate_bounding_sphere
  end

  def calculate_bounding_box(vertices)
    min_x = 0
    min_y = 0
    min_z = 0
    max_x = 0
    max_y = 0
    max_z = 0

    vertices.each do |vertex|
      min_x = [min_x, vertex.x].min
      max_x = [max_x, vertex.x].max
      min_y = [min_y, vertex.y].min
      max_y = [max_y, vertex.y].max
      min_z = [min_z, vertex.z].min
      max_z = [max_z, vertex.z].max
    end

    @min_x = min_x
    @min_y = min_y
    @min_z = min_z
    @max_x = max_x
    @max_y = max_y
    @max_z = max_z
  end

  def calculate_bounding_sphere
    center_x = (@min_x + @max_x) / 2
    center_y = (@min_y + @max_y) / 2
    center_z = (@min_z + @max_z) / 2
    xd = @max_x - center_x
    yd = @max_y - center_y
    zd = @max_z - center_z
    @radius = Math.sqrt(xd * xd + yd * yd + zd * zd)
    @center_x = center_x
    @center_y = center_y
    @center_z = center_z
  end

  def minX
    @min_x
  end

  def minY
    @min_y
  end

  def minZ
    @min_z
  end

  def maxX
    @max_x
  end

  def maxY
    @max_y
  end

  def maxZ
    @max_z
  end

  def centerX
    @center_x
  end

  def centerY
    @center_y
  end

  def centerZ
    @center_z
  end

  def radius
    @radius
  end
end