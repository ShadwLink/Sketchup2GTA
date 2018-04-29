class VDrawableExporter

  def export(model_name, ent, scale, export_path)
    materials = get_materials_for_entity(ent)
    bounds = Bounds.new(ent)

    createDir(export_path)
    odr_file_path = "#{export_path}/#{model_name}.odr"
    high_mesh_path = "#{export_path}/#{model_name}_high.mesh"

    File.open(odr_file_path, 'w') do |file|
      file.puts "Version 165 31\n"
      export_odr_header(file, materials, model_name, bounds)
    end

    File.open(high_mesh_path, 'w') do |file|
      export_mesh(ent, file, materials, bounds, scale)
    end
  end

  def export_odr_header(file, materials, model_name, bounds)
    file.puts "{"
    export_shading_group(file, materials)
    export_skeleton(file)
    export_lod_group(file, model_name, bounds)
    export_joints(file)
    export_light(file)
    export_bound(file)
    file.puts "}\n"
  end

  def export_shading_group(file, materials)
    file.puts "\tShaders\n"
    file.puts "\t{\n"
    materials.each do |material|
      file.puts "\t\tdefault.sps\n"
      file.puts "\t\t{"
      file.puts "\t\t\tDiffuseSampler #{stripTexName(material.texture.filename)}\n"
      file.puts "\t\t\tHardAlphaBlend 1.00000000\n"
      file.puts "\t\t\tUseTessellation 0.00000000\n"
      file.puts "\t\t}"
    end
    file.puts "\t}\n"
  end

  def export_skeleton(file)
    file.puts "\tSkeleton null"
  end

  def export_lod_group(file, model_name, bounds)
    file.puts "\tLodGroup\n"
    file.puts "\t{\n"
    file.puts "\t\tCenter #{bounds.centerX} #{bounds.centerY} #{bounds.centerZ}\n"
    file.puts "\t\tRadius #{bounds.radius}\n"
    file.puts "\t\tAABBMin #{bounds.minX} #{bounds.minY} #{bounds.minZ}\n"
    file.puts "\t\tAABBMax #{bounds.maxX} #{bounds.maxY} #{bounds.maxZ}\n"
    file.puts "\t\tHigh 9998.00000000\n"
    file.puts "\t\t{\n"
    file.puts "\t\t\t#{model_name}_high.mesh 0\n"
    file.puts "\t\t}\n"
    file.puts "\t\tMed 9998.00000000\n"
    file.puts "\t\tLow 9998.00000000\n"
    file.puts "\t\tVlow 9998.00000000\n"
    file.puts "\t}\n"
  end

  def export_joints(file)
    file.puts("\tJoints null")
  end

  def export_light(file)
    file.puts("\tLight null")
  end

  def export_bound(file)
    file.puts("\tBound null")
  end

  def export_mesh(ent, file, materials, bounds, scale)

  end

end