require 'shadowlink_gta_exporter/mesh.rb'

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

# Returns vertex scale
def getVertexScaleMinMax(bounds)
  scale = Array.new(3)

  num = bounds.maxX / 32767
  num2 = bounds.minX / -32768
  if num > num2
    scale[0] = num
  else
    scale[0] = num2
  end

  num = bounds.maxX / 32767
  num2 = bounds.minY / -32768
  if num > num2
    scale[1] = num
  else
    scale[1] = num2
  end

  num = bounds.maxZ / 32767
  num2 = bounds.minZ / -32768
  if num > num2
    scale[2] = num
  else
    scale[2] = num2
  end

  scale[0] = scale[0].round_to(8)
  scale[1] = scale[1].round_to(8)
  scale[2] = scale[2].round_to(8)

  return scale
end

# Remove filepath/extension from texname
def stripTexName(texName)
  test = texName.index('/')

  if test.nil?
    test = texName.index('\\') # Search for first occurance of \

    while !test.nil? # Does it even occur?
      texName = texName[test + 1, texName.length - test] # Create a substring
      test = texName.index('\\') # Get next occurance
    end

    texName = texName[0, texName.length - 4] # Remove the extension
  else
    while !test.nil? # Does it even occur?
      texName = texName[test + 1, texName.length - test] # Create a substring
      test = texName.index('/') # Get next occurance
    end

    texName = texName[0, texName.length - 4] # Remove the extension
  end

  texName.gsub!(' ', '_')
  texName.gsub!('-', '_')

  return texName
end

# Jenkins one-at-a-time hash fucntion
def getStableHash(str)
  str.downcase!

  max_32_bit = 4294967295
  hash = 0
  str.length.times {|n|
    hash += str[n].ord
    hash &= max_32_bit
    hash += ((hash << 10) & max_32_bit)
    hash &= max_32_bit
    hash ^= hash >> 6
  }
  hash += (hash << 3 & max_32_bit)
  hash &= max_32_bit
  hash ^= hash >> 11
  hash += (hash << 15 & max_32_bit)
  hash &= max_32_bit
  hash
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

def getUniqueComponents()
  comps = Sketchup.active_model.active_entities.find_all {|group| group.typename == "ComponentInstance"} # Get all components enteties
  uniqueComps = []
  puts "Comps: " + comps.length.to_s
  comps.each {|comp|
    if getFileName(comp) != "sl_iv_car"
      if (comp.definition.get_attribute 'sl_iv_ide', 'modelName') != nil
        found = false
        uniqueComps.each {|uniq|
          if getFileName(uniq) == getFileName(comp)
            found = true
          end
        }
        if found == false
          uniqueComps.push(comp)
        end
      end
    end
  }
  puts "Comps: " + comps.length.to_s + "/" + uniqueComps.length.to_s
  return uniqueComps
end

def getCarHash(ent)
  hash = 0
  carName = ent.definition.get_attribute 'sl_iv_ide', 'carName'
  if carName != nil && carName != "random"
    hash = getStableHash(carName)
  end
  hash = getStableHash("ambulance")
  return hash
end

def createDir(name)
  if File.exists?(name) && File.directory?(name)
  else
    Dir.mkdir(name)
  end
end

def GetScale()
  return 1.27
end

def get_model_name(ent)
  model_name = ent.definition.get_attribute 'sl_iv_ide', 'modelName'
  if (model_name) == nil
    model_name = ent.definition.name
  end
  model_name
end

def get_meshes(materials, entity)
  meshes = []
  faces = entity.definition.entities.find_all {|e| e.typename == "Face"} # Get all face enteties
  materials.each do |material|
    meshes.push(get_mesh(material, faces))
  end
  meshes
end

def get_mesh(material, faces)
  faces_for_material = get_faces_for_material(faces, material)
  Mesh.new(faces_for_material)
end

def get_faces_for_material(all_faces, material)
  faces = []

  all_faces.each do |face|
    if face.material == material
      faces.push(face)
    end
  end

  faces
end

def get_texture_name(material)
  stripTexName(material.texture.filename)
end

def get_texture_extension(material)
  File.extname(material.texture.filename)
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