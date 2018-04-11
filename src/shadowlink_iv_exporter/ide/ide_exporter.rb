def export_ide(exportPath)
  export_ide(exportPath)
end

def export_ide(ent, minmax, bounds, exportPath)
  ent_def = ent.definition

  modelName = ent_def.get_attribute 'sl_iv_ide', 'modelName'
  wtdName = ent_def.get_attribute 'sl_iv_ide', 'wtdName'
  drawDist = ent_def.get_attribute 'sl_iv_ide', 'drawDist'
  ideName = ent_def.get_attribute 'sl_iv_ide', 'ideName'

  filePath = exportPath + ideName

  if File::exists?(filePath)
    File.open(filePath, 'r') do |old|
      File.open(filePath + ".tmp", 'w') do |new|
        line = old.gets
        while (line != "end\n")
          wdrIndex = line.index(modelName + ",")
          if wdrIndex.nil?
            new.puts line
          end
          line = old.gets
        end
        new.puts modelName + ", " + wtdName + ", " + drawDist + ", 0, 0, " + minmax[0].to_s + ", " + minmax[1].to_s + ", " + minmax[2].to_s + ", " + minmax[3].to_s + ", " + minmax[4].to_s + ", " + minmax[5].to_s + ", " + bounds[0].to_s + ", " + bounds[1].to_s + ", " + bounds[2].to_s + ", " + bounds[3].to_s + ", null\n"
        new.puts "end\n"
        while (line = old.gets)
          new.puts line
        end
      end
    end
    File.delete(filePath)
    File.rename(filePath + ".tmp", filePath)
  else
    File.open(filePath, 'w') do |new|
      new.puts "objs\n"
      new.puts modelName + ", " + wtdName + ", " + drawDist + ", 0, 0, " + minmax[0].to_s + ", " + minmax[1].to_s + ", " + minmax[2].to_s + ", " + minmax[3].to_s + ", " + minmax[4].to_s + ", " + minmax[5].to_s + ", " + bounds[0].to_s + ", " + bounds[1].to_s + ", " + bounds[2].to_s + ", " + bounds[3].to_s + ", null\n"
      new.puts "end\ntobj\nend\ntree\nend\npath\nend\nanim\nend\ntanm\nend\nmlo\nend\n2dfx\nend\ntxdp\nend\n"
    end
  end
end