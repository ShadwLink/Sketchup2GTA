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