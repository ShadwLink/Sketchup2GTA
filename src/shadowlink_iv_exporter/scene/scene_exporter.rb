def export_scene(exportPath)
  entities = getUniqueComponents()

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

      puts "Exporting ide " + getFileName(ent)
      export_ide(ent, minmax, bounds, exportPath)
      puts "Exporting wdr " + getFileName(ent)
      export_wdr(ent, materials, scale, exportPath)
      puts "Exporting wbd " + getFileName(ent)
      export_wbd(ent, verts, minmax, bounds, scale, exportPath)
      puts "Exporting tex " + getFileName(ent)
      export_textures(ent, materials, exportPath)
    end
  end

  puts "Exporting wpl"
  export_wpl("/test/")#exportPath)
  # };
end