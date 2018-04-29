def export_scene(export_path)
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
      scale = GetScale()

      puts "Exporting ide " + getFileName(ent)
      export_ide(ent, export_path)
      puts "Exporting wdr " + getFileName(ent)
      export(ent, materials, scale, export_path)
      puts "Exporting wbd " + getFileName(ent)
      export_obn(ent, scale, export_path)
      puts "Exporting tex " + getFileName(ent)
      export(ent, export_path)
    end
  end

  puts "Exporting wpl"
  export_wpl(export_path)
end