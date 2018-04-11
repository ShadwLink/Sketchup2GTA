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
  bounds = Bounds.new(ent)
  model_name = "model"
  wtd_name = "wtd"
  draw_dist = 100.0
  file.puts "#{model_name}, #{wtd_name}, #{draw_dist}, 0, 0, #{bounds.minX.to_s}, #{bounds.minY.to_s}, #{bounds.minZ.to_s}, #{bounds.maxX.to_s}, #{bounds.maxY.to_s}, #{bounds.maxZ.to_s}, #{bounds.centerX.to_s}, #{bounds.centerY.to_s}, #{bounds.centerZ.to_s}, #{bounds.radius.to_s}, null\n"
end

# def export_ide(ent, minmax, bounds, export_path)
#   ent_def = ent.definition
#
#   modelName = ent_def.get_attribute 'sl_iv_ide', 'modelName'
#   wtdName = ent_def.get_attribute 'sl_iv_ide', 'wtdName'
#   drawDist = ent_def.get_attribute 'sl_iv_ide', 'drawDist'
#   ideName = ent_def.get_attribute 'sl_iv_ide', 'ideName'
#
#   filePath = export_path + ideName
#
#   if File::exists?(filePath)
#     File.open(filePath, 'r') do |old|
#       File.open(filePath + ".tmp", 'w') do |new|
#         line = old.gets
#         while (line != "end\n")
#           wdrIndex = line.index(modelName + ",")
#           if wdrIndex.nil?
#             new.puts line
#           end
#           line = old.gets
#         end
#         new.puts modelName + ", " + wtdName + ", " + drawDist + ", 0, 0, " + minmax[0].to_s + ", " + minmax[1].to_s + ", " + minmax[2].to_s + ", " + minmax[3].to_s + ", " + minmax[4].to_s + ", " + minmax[5].to_s + ", " + bounds[0].to_s + ", " + bounds[1].to_s + ", " + bounds[2].to_s + ", " + bounds[3].to_s + ", null\n"
#         new.puts "end\n"
#         while (line = old.gets)
#           new.puts line
#         end
#       end
#     end
#     File.delete(filePath)
#     File.rename(filePath + ".tmp", filePath)
#   else
#     File.open(filePath, 'w') do |new|
#       new.puts "objs\n"
#       new.puts modelName + ", " + wtdName + ", " + drawDist + ", 0, 0, " + minmax[0].to_s + ", " + minmax[1].to_s + ", " + minmax[2].to_s + ", " + minmax[3].to_s + ", " + minmax[4].to_s + ", " + minmax[5].to_s + ", " + bounds[0].to_s + ", " + bounds[1].to_s + ", " + bounds[2].to_s + ", " + bounds[3].to_s + ", null\n"
#       new.puts "end\ntobj\nend\ntree\nend\npath\nend\nanim\nend\ntanm\nend\nmlo\nend\n2dfx\nend\ntxdp\nend\n"
#     end
#   end
# end