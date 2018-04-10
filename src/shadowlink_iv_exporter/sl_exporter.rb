def export_scene
  exportPath = UI.savepanel "Select export directory", "", "export"
  exportPath = exportPath[0, exportPath.length - 6] # Remove the extension

  entities = getUniqueComponents()

  # pb = Squall::ProgressBar.new(entities.length * 4);
  # pb.onCancel() {puts "cancel"};

  # pb.process() {
    entities.each do |ent|
      puts "Starting export " + getFileName(ent)
      materials = []
      verts = []

      # fuck the purge_unused function apparently that's not perfect, so here is a custom one
      faces = ent.definition.entities.find_all {|e| e.typename == "Face"} # Get all face enteties
      faces.each do |face| # For each face
        if face.material != nil
          matIndex = materials.index face.material
          unless matIndex # Check if this material is already in the array
            if face.material.texture != nil
              materials.push(face.material)
            end
          end
        end

        mesh = face.mesh 5 # Create a trimesh of the face
        polys = mesh.polygons # Get all the polygons of this face
        points = mesh.points # Get all vertices of this mesh
        points.each do |p| # For each vertice in this mesh
          vertIndex = verts.index p # Check if this vertice is already in the mesh
          unless vertIndex # If it's not in the mesh
            verts.push(p) # Add it to the vertice array
          end
        end
      end

      if verts.length > 0
        minmax = getBoundsMinMax(verts) # Get max bounds
        bounds = getBoundsCenterMinMax(minmax) # Get center bounds
        scale = GetScale()

        # pb.progress();
        puts "Exporting ide " + getFileName(ent)
        export_ide(ent, minmax, bounds, exportPath)
        # pb.progress();
        puts "Exporting wdr " + getFileName(ent)
        export_wdr(ent, materials, verts, minmax, bounds, scale, exportPath)
        # pb.progress();
        puts "Exporting wbd " + getFileName(ent)
        export_wbd(ent, verts, minmax, bounds, scale, exportPath)
        # pb.progress();
        puts "Exporting tex " + getFileName(ent)
        export_textures(ent, materials, exportPath)
      end
    end

    puts "Exporting wpl"
    export_wpl("/test/")#exportPath)
  # };
end

def export_ide(ent, minmax, bounds, exportPath)
  ent_def = ent.definition

  modelName = ent_def.get_attribute 'sl_iv_ide', 'modelName'
  wtdName = ent_def.get_attribute 'sl_iv_ide', 'wtdName'
  drawDist = ent_def.get_attribute 'sl_iv_ide', 'drawDist'
  ideName = ent_def.get_attribute 'sl_iv_ide', 'ideName'

  filePath = exportPath + ideName

  if File::exists?(filePath)
    File.open(filePath, 'r') do |old|
      File.open(filePath + ".tmp", 'w') do |new|
        line = old.gets
        while (line != "end\n")
          wdrIndex = line.index(modelName + ",")
          if wdrIndex.nil?
            new.puts line
          end
          line = old.gets
        end
        new.puts modelName + ", " + wtdName + ", " + drawDist + ", 0, 0, " + minmax[0].to_s + ", " + minmax[1].to_s + ", " + minmax[2].to_s + ", " + minmax[3].to_s + ", " + minmax[4].to_s + ", " + minmax[5].to_s + ", " + bounds[0].to_s + ", " + bounds[1].to_s + ", " + bounds[2].to_s + ", " + bounds[3].to_s + ", null\n"
        new.puts "end\n"
        while (line = old.gets)
          new.puts line
        end
      end
    end
    File.delete(filePath)
    File.rename(filePath + ".tmp", filePath)
  else
    File.open(filePath, 'w') do |new|
      new.puts "objs\n"
      new.puts modelName + ", " + wtdName + ", " + drawDist + ", 0, 0, " + minmax[0].to_s + ", " + minmax[1].to_s + ", " + minmax[2].to_s + ", " + minmax[3].to_s + ", " + minmax[4].to_s + ", " + minmax[5].to_s + ", " + bounds[0].to_s + ", " + bounds[1].to_s + ", " + bounds[2].to_s + ", " + bounds[3].to_s + ", null\n"
      new.puts "end\ntobj\nend\ntree\nend\npath\nend\nanim\nend\ntanm\nend\nmlo\nend\n2dfx\nend\ntxdp\nend\n"
    end
  end
end

def export_wdr(ent, materials, verts, minmax, bounds, scale, exportPath)
  fileName = getFileName(ent)

  ideName = ent.definition.get_attribute 'sl_iv_ide', 'ideName'
  imgName = ideName[0, ideName.length - 4] + "_img"

  exportPath = exportPath + imgName + "/"
  createDir(exportPath)

  filePath = exportPath + fileName

  geoCount = [materials.length] # Geometry count

  vertexCount = 0 # Keeps track of vertex count
  triCount = 0 # Keeps track of triangle count

  # First thing we want to do here is create an array of all vertices
  verts = [] # Array that keeps track of the verts
  polyArray = [] # Array that keeps track of the polys
  polyMaterials = [] # Array that keeps track of the poly materials


  # Create a new file and write to it
  File.open(filePath + ".odr", 'w') do |f|
    f.puts "Version 110 12\n" # version
    f.puts "shadinggroup\n{" # shading group
    f.puts "\tShaders " + materials.length.to_s + "\n\t{\n"
    materials.each do |mat| # Split the model up per material
      f.puts "\t\tgta_default.sps " + stripTexName(mat.texture.filename) + "\n"
    end
    f.puts "\t}\n"
    f.puts "}\n"
    f.puts "lodgroup\n{\n"
    f.puts "\thigh 1 " + fileName + "_high.mesh 0 9999.00000000\n"
    f.puts "\tmed none 9999.00000000\n"
    f.puts "\tlow none 9999.00000000\n"
    f.puts "\tvlow none 9999.00000000\n"
    f.puts "\tcenter " + bounds[0].to_s + " " + bounds[1].to_s + " " + bounds[2].to_s + "\n"
    f.puts "\tAABBMin " + minmax[0].to_s + " " + minmax[1].to_s + " " + minmax[2].to_s + "\n"
    f.puts "\tAABBMax " + minmax[3].to_s + " " + minmax[4].to_s + " " + minmax[5].to_s + "\n"
    f.puts "\tradius " + bounds[3].to_s + "\n"
    f.puts "}\n"
  end

  File.open(filePath + '_high.mesh', 'w') do |f|
    f.puts "Version 11 12\n" # version
    f.puts "{" # shading group
    f.puts "\tSkinned 0\n"
    f.puts "\tBounds " + (materials.length + 1).to_s + "\n\t{\n"
    materials.each do |mat| # Split the model up per material
      # TODO: Should be per material bounds
      f.puts "\t\t" + bounds[0].to_s + " " + bounds[1].to_s + " " + bounds[2].to_s + " " + bounds[3].to_s + "\n"
    end
    f.puts "\t\t" + bounds[0].to_s + " " + bounds[1].to_s + " " + bounds[2].to_s + " " + bounds[3].to_s + "\n"
    f.puts "\t}\n"
    count = 0
    materials.each do |mat| # Split the model up per material

      # This is where we collect the needed data
      verts = [] # Array that keeps track of the verts
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
            vertIndex = verts.index p # Check if this vertice is already in the mesh

            uv = mesh.uv_at(pointIndex, true) # Get the UV map of the front face
            normal = mesh.normal_at pointIndex # Get the normal
            pointIndex += 1 # Increase the current point index


            verts.push(p) # Add it to the vertice array
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
      vertCount[0] = verts.length

      f.puts "\tMtl " + count.to_s + "\n\t{\n" # TODO: Add index
      f.puts "\t\tPrim 0\n\t\t{\n"
      f.puts "\t\t\tIdx " + (faceCount[0] * 3).to_s + "\n\t\t\t{\n" # TODO: Add index count
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
      f.puts polyLine
      f.puts "\t\t\t}\n"

      #verts
      f.puts "\t\t\tVerts " + verts.length.to_s + "\n\t\t\t{\n" # TODO: Add vert count
      iVertIndex = 0
      verts.each do |vert|
        vertexX = [vert.x * 0.0254 * scale]
        vertexY = [vert.y * 0.0254 * scale]
        vertexZ = [vert.z * 0.0254 * scale]
        normX = [normals[iVertIndex].x]
        normY = [normals[iVertIndex].y]
        normZ = [normals[iVertIndex].z]
        uvU = [uvs[iVertIndex].x * 1]
        uvV = [uvs[iVertIndex].y * -1]
        f.puts "\t\t\t\t" + vertexX.to_s + " " + vertexY.to_s + " " + vertexZ.to_s + " / " + normX.to_s + " " + normY.to_s + " " + normZ.to_s + " / 255 255 255 255 / 0.0 0.0 0.0 / " + uvU.to_s + " " + uvV.to_s + " / 0.0 0.0 / 0.0 0.0 / 0.0 0.0 / 0.0 0.0 / 0.0 0.0\n"
        iVertIndex += 1
      end
      f.puts "\t\t\t}\n"
      f.puts "\t\t}\n"
      f.puts "\t}\n"
      count += 1
    end
    f.puts "}\n"
  end
end

def export_wbd(ent, verts, minmax, bounds, scale, exportPath)
  fileName = getFileName(ent)

  ideName = ent.definition.get_attribute 'sl_iv_ide', 'ideName'
  imgName = ideName[0, ideName.length - 4] + "_img"

  exportPath = exportPath + imgName + "/"
  createDir(exportPath)

  filePath = exportPath + fileName + ".obd"

  # Retrieve vertex and facecount
  vertexCount = 0 # Keeps track of vertex count
  triCount = 0 # Keeps track of triangle count

  polyArray = [] # Array that keeps track of the polys
  polyMaterials = [] # Array that keeps track of the poly materials

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

  vertexScale = getVertexScaleMinMax(minmax)

  # Create a new file and write to it
  File.open(filePath, 'w') do |f|
    # use "\n" for two lines of text
    f.puts "Version 32 11\n"
    f.puts "{"
    f.puts "\tphBound " + fileName + "\n" # 0 should be id
    f.puts "\t{\n"
    f.puts "\t\tType BoundBVH\n"
    f.puts "\t\tCentroidPresent 1\n"
    f.puts "\t\tCGPresent 1\n"
    f.puts "\t\tRadius " + bounds[3].to_s + "\n"
    f.puts "\t\tWorldRadius " + bounds[3].to_s + "\n"
    f.puts "\t\tAABBMax " + minmax[3].to_s + " " + minmax[4].to_s + " " + minmax[5].to_s + "\n"
    f.puts "\t\tAABBMin " + minmax[0].to_s + " " + minmax[1].to_s + " " + minmax[2].to_s + "\n"
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

def export_textures(ent, materials, exportPath)
  ideName = ent.definition.get_attribute 'sl_iv_ide', 'ideName'
  wtdName = ent.definition.get_attribute 'sl_iv_ide', 'wtdName'
  imgName = ideName[0, ideName.length - 4] + "_img"

  exportPath = exportPath + imgName + "/"
  createDir(exportPath)
  exportPath = exportPath + wtdName + "/"
  createDir(exportPath)

  tw = Sketchup.create_texture_writer

  materials.each do |mat|
    matDone = false
    faces = ent.definition.entities.find_all {|e| e.typename == "Face"} # Get all face enteties
    faces.each do |face|
      if matDone == false
        if face.material == mat
          tw.load face, true
          return_val = tw.write(face, true, exportPath + stripTexName(face.material.texture.filename) + ".png")
          matDone = true
        end
      end
    end
  end
end