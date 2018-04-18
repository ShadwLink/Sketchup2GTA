def export_odr(model_name, ent, scale, export_path)
  materials = get_materials_for_entity(ent)
  bounds = Bounds.new(ent)

  createDir(export_path)
  odr_file_path = "#{export_path}/#{model_name}.odr"
  high_mesh_path = "#{export_path}/#{model_name}_high.mesh"

  File.open(odr_file_path, 'w') do |file|
    file.puts "Version 110 12\n"
    export_odr_header(file, materials, model_name, bounds)
  end

  File.open(high_mesh_path, 'w') do |file|
    export_mesh(ent, file, materials, bounds, scale)
  end
end

def export_odr_header(file, materials, model_name, bounds)
  export_shading_group(file, materials)
  export_lod_group(file, model_name, bounds)
end

def export_shading_group(file, materials)
  file.puts "shadinggroup\n{"
  file.puts "\tShaders " + materials.length.to_s + "\n\t{\n"
  materials.each do |material|
    file.puts "\t\tgta_default.sps " + stripTexName(material.texture.filename) + "\n"
  end
  file.puts "\t}\n"
  file.puts "}\n"
end

def export_lod_group(file, model_name, bounds)
  file.puts "lodgroup\n{\n"
  file.puts "\thigh 1 #{model_name}_high.mesh 0 9999.00000000\n"
  file.puts "\tmed none 9999.00000000\n"
  file.puts "\tlow none 9999.00000000\n"
  file.puts "\tvlow none 9999.00000000\n"
  file.puts "\tcenter " + bounds.centerX.to_s + " " + bounds.centerY.to_s + " " + bounds.centerZ.to_s + "\n"
  file.puts "\tAABBMin " + bounds.minX.to_s + " " + bounds.minY.to_s + " " + bounds.minZ.to_s + "\n"
  file.puts "\tAABBMax " + bounds.maxX.to_s + " " + bounds.maxY.to_s + " " + bounds.maxZ.to_s + "\n"
  file.puts "\tradius " + bounds.radius.to_s + "\n"
  file.puts "}\n"
end

def export_mesh(ent, file, materials, bounds, scale)
  file.puts "Version 11 12\n"
  file.puts "{"
  file.puts "\tSkinned 0\n"
  file.puts "\tBounds " + (materials.length + 1).to_s + "\n\t{\n"
  materials.each do |material|
    file.puts "\t\t" + bounds.centerX.to_s + " " + bounds.centerY.to_s + " " + bounds.centerZ.to_s + " " + bounds.radius.to_s + "\n"
  end
  file.puts "\t\t" + bounds.centerX.to_s + " " + bounds.centerY.to_s + " " + bounds.centerZ.to_s + " " + bounds.radius.to_s + "\n"
  file.puts "\t}\n"
  count = 0
  materials.each do |mat| # Split the model up per material

    # This is where we collect the needed data
    vertices = [] # Array that keeps track of the verts
    uvs = [] # Array that keeps track of the verts uv coords
    normals = [] # Array that keeps track of the verts normals
    polyArray = [] # Array that keeps track of the polys

    vertCount = [0] # The amount of vertices (This one is incorrect)
    faceCount = [0] # The amount of faces (Correct)

    curVertexCount = 0

    faces = ent.definition.entities.find_all {|e| e.typename == "Face"} # Get all face enteties
    faces.each do |face| # For each face
      if face.material == mat # Check if the face uses this split material

        mesh = face.mesh 5 # Create a trimesh of the face

        polys = mesh.polygons # Get all the polygons of this face

        points = mesh.points # Get all vertices of this mesh

        pointIndex = 1
        points.each do |p| # For each vertice in this mesh
          vertIndex = vertices.index p # Check if this vertice is already in the mesh

          uv = mesh.uv_at(pointIndex, true) # Get the UV map of the front face
          normal = mesh.normal_at pointIndex # Get the normal
          pointIndex += 1 # Increase the current point index


          vertices.push(p) # Add it to the vertice array
          uvs.push(uv) # Add it to the UV array
          normals.push(normal)
        end

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
          p1 = poly[0] - 1 + curVertexCount
          p2 = poly[1] - 1 + curVertexCount
          p3 = poly[2] - 1 + curVertexCount

          polyArray.push(p1) #value1)
          polyArray.push(p2) #value2)
          polyArray.push(p3) #value3)
        end
        faceCount[0] += polys.length # Increase the facecount
        curVertexCount += points.length
      end
    end

    # Print face vert count
    vertCount[0] = vertices.length

    file.puts "\tMtl " + count.to_s + "\n\t{\n" # TODO: Add index
    file.puts "\t\tPrim 0\n\t\t{\n"
    file.puts "\t\t\tIdx " + (faceCount[0] * 3).to_s + "\n\t\t\t{\n" # TODO: Add index count
    test = 0
    curLength = 0
    polyLine = ""
    while test < polyArray.length
      if curLength == 0
        polyLine += "\t\t\t\t"
      end
      polyLine += polyArray[test].to_s + " " + polyArray[test + 1].to_s + " " + polyArray[test + 2].to_s + " "
      curLength += 1
      if curLength >= 5
        polyLine += "\n"
        curLength = 0
      end

      test += 3
    end
    file.puts polyLine
    file.puts "\t\t\t}\n"

    #verts
    file.puts "\t\t\tVerts " + vertices.length.to_s + "\n\t\t\t{\n" # TODO: Add vert count
    vertexIndex = 0
    vertices.each do |vert|
      vertexX = vert.x * 0.0254 * scale
      vertexY = vert.y * 0.0254 * scale
      vertexZ = vert.z * 0.0254 * scale
      normX = normals[vertexIndex].x
      normY = normals[vertexIndex].y
      normZ = normals[vertexIndex].z
      uvU = uvs[vertexIndex].x * 1
      uvV = uvs[vertexIndex].y * -1
      file.puts "\t\t\t\t" + vertexX.round(MAX_DECIMALS).to_s + " " + vertexY.round(MAX_DECIMALS).to_s + " " + vertexZ.round(MAX_DECIMALS).to_s + " / " + normX.round(MAX_DECIMALS).to_s + " " + normY.round(MAX_DECIMALS).to_s + " " + normZ.round(MAX_DECIMALS).to_s + " / 255 255 255 255 / 0.0 0.0 0.0 / " + uvU.round(MAX_DECIMALS).to_s + " " + uvV.round(MAX_DECIMALS).to_s + " / 0.0 0.0 / 0.0 0.0 / 0.0 0.0 / 0.0 0.0 / 0.0 0.0\n"
      vertexIndex += 1
    end
    file.puts "\t\t\t}\n"
    file.puts "\t\t}\n"
    file.puts "\t}\n"
    count += 1
  end
  file.puts "}\n"
end