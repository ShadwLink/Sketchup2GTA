require 'shadowlink_gta_exporter/utils/mip_map_level_calculator'

class VTextureExporter

  def export(entities, export_path)
    entities.each do |ent|
      export_entity_textures(ent, export_path)
    end
  end

  def export_entity_textures(ent, export_path)
    materials = get_materials_for_entity(ent)
    dictionary_name = ent.definition.name
    dictionary_path = "#{export_path}/#{dictionary_name}"
    otd_file = "#{export_path}/#{dictionary_name}.otd"

    File.open(otd_file, 'w') do |file|
      export_otd(file, dictionary_name, materials)
    end

    createDir(dictionary_path)
    materials.each do |material|
      material.texture.write("#{dictionary_path}/#{get_texture_name(material)}#{get_texture_extension(material)}", true)

      otx_file = "#{dictionary_path}/#{get_texture_name(material)}.otx"
      File.open(otx_file, 'w') do |file|
        export_otx(file, material)
      end
    end
  end

  def export_otd(file, dictionary_name, materials)
    file.puts("Version 13 30")
    file.puts("{")
    materials.each do |material|
      file.puts("\t#{dictionary_name}\\#{get_texture_name(material)}.otx")
    end
    file.puts("}")
  end

  def export_otx(file, material)
    mipmap_level = MipMapLevelCalculator.new().calculate_mipmap_count(material.texture.image_width, material.texture.image_height)

    file.puts("Version 13 30")
    file.puts("{")
    file.puts("\tImage #{get_texture_name(material)}#{get_texture_extension(material)}")
    file.puts("\tType Regular")
    file.puts("\tPixelFormat DXT1")
    file.puts("\tLevels #{mipmap_level}")
    file.puts("\tUsage NORMAL")
    file.puts("\tUsageFlags HD_SPLIT")
    file.puts("\tExtraFlags 0")
    file.puts("}")
  end

end