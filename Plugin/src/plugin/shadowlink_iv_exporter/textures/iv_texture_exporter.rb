require 'shadowlink_iv_exporter/utils/mip_map_level_calculator'

class IVTextureExporter

  def export(entities, export_path)
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
        file.puts "\t\tName #{dictionary_name}\\#{get_texture_name(material)}#{get_texture_extension(material)}"
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
    dictionary_name = ent.definition.name
    dictionary_path = "#{export_path}/#{dictionary_name}"
    otd_file = "#{export_path}/#{dictionary_name}.otd"

    File.open(otd_file, 'w') do |file|
      export_open_formats(file, dictionary_name, materials)
    end

    createDir(dictionary_path)
    materials.each do |material|
      material.texture.write("#{dictionary_path}/#{get_texture_name(material)}#{get_texture_extension(material)}", true)
    end
  end

end