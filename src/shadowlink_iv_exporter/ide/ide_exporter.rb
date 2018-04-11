Sketchup.load 'shadowlink_iv_exporter/bounds.rb'

def export_ide(entities, export_path)
  file_path = "#{export_path}/test.ide"

  File.open(file_path, 'w') do |file|
    write_objects(entities, file)
    file.puts "tobj\nend\ntree\nend\npath\nend\nanim\nend\ntanm\nend\nmlo\nend\n2dfx\nend\ntxdp\nend\n"
  end
end

def write_objects(entities, file)
  file.puts "objs\n"
  entities.each do |ent|
    write_object(ent, file)
  end
  file.puts "end\n"
end

def write_object(ent, file)
  # TODO: Use attributes
  #   modelName = ent_def.get_attribute 'sl_iv_ide', 'modelName'
  #   wtdName = ent_def.get_attribute 'sl_iv_ide', 'wtdName'
  #   drawDist = ent_def.get_attribute 'sl_iv_ide', 'drawDist'
  #   ideName = ent_def.get_attribute 'sl_iv_ide', 'ideName'

  bounds = Bounds.new(ent)
  model_name = "model"
  wtd_name = "wtd"
  draw_dist = 100.0
  file.puts "#{model_name}, #{wtd_name}, #{draw_dist}, 0, 0, #{bounds.minX.to_s}, #{bounds.minY.to_s}, #{bounds.minZ.to_s}, #{bounds.maxX.to_s}, #{bounds.maxY.to_s}, #{bounds.maxZ.to_s}, #{bounds.centerX.to_s}, #{bounds.centerY.to_s}, #{bounds.centerZ.to_s}, #{bounds.radius.to_s}, null\n"
end