class Float
  def round_to(x)
    (self * 10 ** x).round.to_f / 10 ** x
  end

  def ceil_to(x)
    (self * 10 ** x).ceil.to_f / 10 ** x
  end

  def floor_to(x)
    (self * 10 ** x).floor.to_f / 10 ** x
  end
end

def getFileName(ent)
  name = ent.name
  if name == ""
    name = ent.definition.name
    tagIndex = name.index('#')
    if !tagIndex.nil?
      name = name[0, tagIndex]
    end
  end
  return name
end

def createDir(name)
  if File.exists?(name) && File.directory?(name)
  else
    Dir.mkdir(name)
  end
end
