class BoundsDictionaryExporter

  def export(obd_name, file_path, entities)
    obd_file_path = "#{file_path}/#{obd_name}.obd"

    File.open(obd_file_path, 'w') do |file|
      file.puts "Version 32 11"
      file.puts "{"
      entities.each do |ent|
        model_name = get_model_name(ent)
        export_bounds(file, ent, GetScale(), model_name)
      end
      file.puts "}"
    end
  end

end