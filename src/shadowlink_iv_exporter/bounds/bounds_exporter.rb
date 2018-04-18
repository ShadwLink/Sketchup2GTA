def export_obn(model_name, ent, scale, export_path)
  verts = get_verts(ent)
  bounds = Bounds.new(ent)

  file_path = "#{export_path}/#{model_name}.obn"

  polyArray = [] # Array that keeps track of the polys

  faces = ent.definition.entities.find_all {|e| e.typename == "Face"} # Get all face enteties
  faces.each do |face| # For each face
    mesh = face.mesh 5 # Create a trimesh of the face

    polys = mesh.polygons # Get all the polygons of this face

    points = mesh.points # Get all vertices of this mesh

    polys.each do |poly| # For all polys

      if poly[0] < 0
        poly[0] *= -1
      end
      if poly[1] < 0
        poly[1] *= -1
      end
      if poly[2] < 0
        poly[2] *= -1
      end

      poly[0] -= 1
      poly[1] -= 1
      poly[2] -= 1

      pointTest1 = points[poly[0]]
      pointTest2 = points[poly[1]]
      pointTest3 = points[poly[2]]

      p1 = verts.index pointTest1
      p2 = verts.index pointTest2
      p3 = verts.index pointTest3

      newPoly = Array.new(3)
      newPoly[0] = p1
      newPoly[1] = p2
      newPoly[2] = p3
      polyArray.push(newPoly)
    end
  end
  # Print face vert count
  vertexCount = verts.length
  triCount = polyArray.length

  vertexScale = getVertexScaleMinMax(bounds)

  # Create a new file and write to it
  File.open(file_path, 'w') do |f|
    # use "\n" for two lines of text
    f.puts "Version 32 11\n"
    f.puts "{"
    f.puts "\tphBound #{model_name}\n" # 0 should be id
    f.puts "\t{\n"
    f.puts "\t\tType BoundBVH\n"
    f.puts "\t\tCentroidPresent 1\n"
    f.puts "\t\tCGPresent 1\n"
    f.puts "\t\tRadius " + bounds.radius.to_s + "\n"
    f.puts "\t\tWorldRadius " + bounds.radius.to_s + "\n"
    f.puts "\t\tAABBMax " + bounds.maxX.to_s + " " + bounds.maxY.to_s + " " + bounds.maxZ.to_s + "\n"
    f.puts "\t\tAABBMin " + bounds.minX.to_s + " " + bounds.minY.to_s + " " + bounds.minZ.to_s + "\n"
    f.puts "\t\tCentroid 0.0 0.0 0.0\n"
    f.puts "\t\tCenterOfMass 0.0 0.0 0.0\n"
    f.puts "\t\tMargin 0.005 0.005 0.005\n"
    f.puts "\t\tPolygons " + triCount.to_s + "\n" # polygon count
    f.puts "\t\t{\n"
    polyID = 0
    polyArray.each do |poly|
      f.puts "\t\t\tPolygon " + polyID.to_s + "\n" #ID
      f.puts "\t\t\t{\n"
      f.puts "\t\t\t\tMaterial 0\n"
      f.puts "\t\t\t\tVertices " + poly[0].to_s + " " + poly[1].to_s + " " + poly[2].to_s + " 0 \n"
      #puts "POLY: " + poly[0].to_s + " " + poly[1].to_s + " " + poly[2].to_s
      f.puts "\t\t\t\tSiblings -1 -1 -1 -1\n"
      f.puts "\t\t\t}\n"
      polyID += 1
    end
    f.puts "\t\t}\n"
    f.puts "\t\tVertexScale " + vertexScale[0].to_s + " " + vertexScale[1].to_s + " " + vertexScale[2].to_s + "\n"
    f.puts "\t\tVertexOffset 0.0 0.0 0.0\n"
    f.puts "\t\tVertices " + vertexCount.to_s + "\n" # Vertex count
    f.puts "\t\t{\n"
    verts.each do |vert|

      vertexX = (vert.x * 0.0254 * scale).round_to(8) / vertexScale[0]
      vertexY = (vert.y * 0.0254 * scale).round_to(8) / vertexScale[1]
      vertexZ = (vert.z * 0.0254 * scale).round_to(8) / vertexScale[2]
      if (vertexX.nan?)
        vertexX = 0;
      end
      if (vertexY.nan?)
        vertexY = 0;
      end
      if (vertexZ.nan?)
        vertexZ = 0;
      end
      vertX = vertexX.to_i
      vertY = vertexY.to_i
      vertZ = vertexZ.to_i
      f.puts "\t\t\t" + vertX.to_s + " " + vertY.to_s + " " + vertZ.to_s + "\n"
    end
    f.puts "\t\t}\n"
    f.puts "\t\tMaterials 1\n" # material count
    f.puts "\t\t{\n"
    #foreachmaterialcount
    f.puts "\t\t\t3 0 0\n"
    f.puts "\t\t}\n"
    f.puts "\t}\n"
    f.puts "}"
  end
end

def get_verts(ent)
  verts = []

  faces = ent.definition.entities.find_all {|e| e.typename == "Face"} # Get all face enteties
  faces.each do |face| # For each face
    mesh = face.mesh 5 # Create a trimesh of the face
    points = mesh.points # Get all vertices of this mesh
    points.each do |p| # For each vertice in this mesh
      unless verts.index p # If it's not in the mesh
        verts.push(p) # Add it to the vertice array
      end
    end
  end

  verts
end