def export_entities_textures(entities, export_path)
  entities.each do |ent|
    export_entity_textures(ent, export_path)
  end
end

def export_entity_textures(ent, export_path)
  materials = get_materials_for_entity(ent)
  ide_name = ent.definition.name #definition.get_attribute 'sl_iv_ide', 'ideName'
  wtd_name = ent.definition.name #definition.get_attribute 'sl_iv_ide', 'wtdName'
  img_name = "#{ide_name}_img"

  image_path = "#{export_path}/#{img_name}/"
  createDir(image_path)
  wtd_path =  "#{export_path}/#{img_name}/#{wtd_name}/"
  createDir(wtd_path)

  tw = Sketchup.create_texture_writer

  materials.each do |mat|
    material_done = false
    faces = ent.definition.entities.find_all {|e| e.typename == "Face"} # Get all face enteties
    faces.each do |face|
      if material_done == false
        if face.material == mat
          tw.load face, true
          return_val = tw.write(face, true, wtd_path + stripTexName(face.material.texture.filename) + ".png")
          material_done = true
        end
      end
    end
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