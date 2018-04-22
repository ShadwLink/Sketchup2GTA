require 'shadowlink_iv_exporter/mip_map_level_calculator'

def export_entities_textures(entities, export_path)
  entities.each do |ent|
    export_entity_textures(ent, export_path)
  end
end

def export_open_formats(file, dictionary_name, materials)
  mipmapLevelCalculator = MipMapLevelCalculator.new

  file.puts "Version 8 10"
  file.puts "{"
  materials.each do |material|
    begin
      mipmap_level = mipmapLevelCalculator.calculate_mipmap_count(material.texture.image_width, material.texture.image_height)
      file.puts "\tgrcTexture"
      file.puts "\t{"
      file.puts "\t\tType regular"
      file.puts "\t\tName #{dictionary_name}\\#{material.texture.filename}"
      file.puts "\t\tMipMaps #{mipmap_level}"
      file.puts "\t\tPixelFormat DXT1" #TODO: Define PixelFormat
      file.puts "\t}"
    rescue ArgumentError => error
      puts "Texture dimensions are invalid: #{error}"
    end
  end
  file.puts "}"
end

def export_entity_textures(ent, export_path)
  materials = get_materials_for_entity(ent)
  dictionary_name = ent.definition.name #definition.get_attribute 'sl_iv_ide', 'wtdName'
  dictionary_path = "#{export_path}/#{dictionary_name}"
  otd_file = "#{export_path}/#{dictionary_name}.otd"

  File.open(otd_file, 'w') do |file|
    export_open_formats(file, dictionary_name, materials)
  end

  createDir(dictionary_path)
  materials.each do |material|
    material.texture.write("#{dictionary_path}/#{stripTexName(material.texture.filename)}.png", true)
  end
end

def get_materials_for_entity(ent)
  materials = []

  faces = ent.definition.entities.find_all {|e| e.typename == "Face"}
  faces.each do |face|
    if face.material != nil
      unless materials.index face.material
        if face.material.texture != nil
          materials.push(face.material)
        end
      end
    end
  end

  materials
end