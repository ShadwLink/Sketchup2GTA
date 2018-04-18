class DrawableDictionaryExporter

  def export(odd_name, file_path, entities)
    createDir(file_path)
    odd_file_path = "#{file_path}/#{odd_name}.odd"

    File.open(odd_file_path, 'w') do |file|
      file.puts "Version 110 12"
      file.puts "{"
      entities.each do |ent|
        model_name = get_model_name(ent)
        file.puts "gtaDrawable #{model_name}"
        file.puts "{"

        materials = get_materials_for_entity(ent)
        bounds = Bounds.new(ent)
        export_odr_header(file, materials, model_name, bounds)

        file.puts "}"
      end
      file.puts "}"
    end

    entities.each do |ent|
      materials = get_materials_for_entity(ent)
      bounds = Bounds.new(ent)
      model_name = get_model_name(ent)

      high_mesh_path = "#{file_path}/#{model_name}_high.mesh"
      File.open(high_mesh_path, 'w') do |file|
        export_mesh(ent, file, materials, bounds, GetScale())
      end
    end
  end
end