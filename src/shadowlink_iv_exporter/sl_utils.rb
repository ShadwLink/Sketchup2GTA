class Float
  def round_to(x)
    (self * 10**x).round.to_f / 10**x
  end

  def ceil_to(x)
    (self * 10**x).ceil.to_f / 10**x
  end

  def floor_to(x)
    (self * 10**x).floor.to_f / 10**x
  end
end

# Get the bounding box max
def getBoundsMinMax( verts )
	bounds = Array.new(6)
	minX = 0
	minY = 1
	minZ = 2
	maxX = 3
	maxY = 4
	maxZ = 5
	
	bounds[minX] = verts[0].x	# Min X
	bounds[minY] = verts[0].y	# Min Y
	bounds[minZ] = verts[0].z	# Min Z
	bounds[maxX] = verts[0].x	# Max X
	bounds[maxY] = verts[0].y	# Max Y
	bounds[maxZ] = verts[0].z	# Max Z
	
	verts.each do |vert|
		if vert.x > bounds[maxX] 
			bounds[maxX] = vert.x
		elsif vert.x < bounds[minX]
			bounds[minX] = vert.x
		end
		if vert.y > bounds[maxY]
			bounds[maxY] = vert.y
		elsif vert.y < bounds[minY]
			bounds[minY] = vert.y
		end
		if vert.z > bounds[maxZ]
			bounds[maxZ] = vert.z
		elsif vert.z < bounds[minZ]
			bounds[minZ] = vert.z
		end
	end
	
	bounds[minX] *= 0.0254
	bounds[minY] *= 0.0254
	bounds[minZ] *= 0.0254
	bounds[maxX] *= 0.0254
	bounds[maxY] *= 0.0254
	bounds[maxZ] *= 0.0254
	
	bounds[minX] *= GetScale()
	bounds[minY] *= GetScale()
	bounds[minZ] *= GetScale()
	bounds[maxX] *= GetScale()
	bounds[maxY] *= GetScale()
	bounds[maxZ] *= GetScale()
	
	bounds[minX] = bounds[minX].round_to(8)
	bounds[minY] = bounds[minY].round_to(8)
	bounds[minZ] = bounds[minZ].round_to(8)
	bounds[maxX] = bounds[maxX].round_to(8)
	bounds[maxY] = bounds[maxY].round_to(8)
	bounds[maxZ] = bounds[maxZ].round_to(8)
	return bounds
end

# Get the bounding box max
def getBoundsCenterMinMax( minmax )
	center = Array.new(4)
	
	center[0] = (minmax[0] + minmax[3]) / 2
	center[1] = (minmax[1] + minmax[4]) / 2
	center[2] = (minmax[2] + minmax[5]) / 2
	
	center[0] = center[0].round_to(8)
	center[1] = center[1].round_to(8)
	center[2] = center[2].round_to(8)
	
	xd = minmax[3] - center[0]
	yd = minmax[4] - center[1]
	zd = minmax[5] - center[2]
	center[3] = Math.sqrt(xd*xd + yd*yd + zd*zd)
	
	return center
end

# Returns vertex scale 
def getVertexScaleMinMax( bounds )
	scale = Array.new(3)
	
	#scale[0] = (minmax[3] - minmax[1]) / 65535
	#scale[1] = (minmax[4] - minmax[2]) / 65535
	#scale[2] = (minmax[5] - minmax[3]) / 65535
	
	num = bounds.maxX / 32767;
	num2 = bounds.minX / -32768;
	if num > num2
		scale[0] = num
	else
		scale[0] = num2
	end
	
	num = bounds.maxX / 32767;
	num2 = bounds.minY / -32768;
	if num > num2
		scale[1] = num
	else
		scale[1] = num2
	end
	
	num = bounds.maxZ / 32767;
	num2 = bounds.minZ / -32768;
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

# Checks if the model is ready for export
def checkModel()
	model = Sketchup.active_model
    materials = model.materials
	materials.purge_unused
	
	materials.each do |mat|
		if mat.texture.nil?
			UI.messagebox(mat.name + " doesn't have a texture!")
			return false
		# Check for extension and img sizes
		#else
			#if mat.texture.image_height
		end
	end
	return true
end

# Remove filepath/extension from texname
def stripTexName( texName )
	test = texName.index('/')
	
	if test.nil?
		test = texName.index('\\')							# Search for first occurance of \
	
		while !test.nil?									# Does it even occur?
			texName = texName[test+1, texName.length-test]	# Create a substring
			test = texName.index('\\')						# Get next occurance
		end
	
		texName = texName[0, texName.length - 4]			# Remove the extension
	else
		while !test.nil?									# Does it even occur?
			texName = texName[test+1, texName.length-test]	# Create a substring
			test = texName.index('/')						# Get next occurance
		end
	
		texName = texName[0, texName.length - 4]			# Remove the extension
	end
	
	texName.gsub!(' ','_')
	texName.gsub!('-','_')
	
	return texName
end

# Checks if a string ends with a string
def ends_with(fileName, str)
	tail = fileName[fileName.length - str.length, fileName.length]
    if tail == str
		return true
	else
		return false
	end
end

#Hashing functions thnx Rais
# Function to truncate value so ruby doesn't keep overflow
def truncate( hash )
	return( hash & 0x00000000FFFFFFFF )
end

# Jenkins one-at-a-time hash fucntion
def getStableHash(str)
	str.downcase!

	max_32_bit = 4294967295
	hash = 0
	str.length.times { |n|
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

def resetAxis(ent)
	model = Sketchup.active_model
	puts "Trans: " + model.edit_transform.to_s
end

def centerAxis()
	model = Sketchup.active_model
    selection = model.selection
	 
	groups = selection.find_all { |group| group.typename == "Group"}	# Get all group enteties

	groups.each do |g|
		bounds = g.local_bounds
		point = Geom::Point3d.new bounds.center[0]*-1,bounds.center[1]*-1,0
	
		t = Geom::Transformation.new point
	
		g = g.move! t
		
		g.explode
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

def getJSONDictionaries(ent)
    json = '{"dictionaries":[';
    dicts = ent.definition.attribute_dictionaries
    if(dicts != nil)
        dicts.each do |dict|
            json += '{"name":"' + dict.name + '","attributes":[';
                
            dict.each_key do |attribName|
                json += '{';
                json += '"name":"' + attribName + '",';
                if(dict[attribName].class != Geom::Transformation)
                    json += '"value":"' + escapeChars(dict[attribName].to_s) + '"},';
                else
					json += '"value":"' + escapeChars(dict[attribName].to_a.to_s) + '"},';
                end
            end
            json += ']},'
        end
    end
    json += "]}";
    json.gsub!(/,/,"#COMMA#");
	puts json;
    return json;
end

def getJSONDictionarie(ent, dictName)
	json = '{';
    dicts = ent.definition.attribute_dictionaries
    if(dicts != nil)
        dicts.each do |dict|
			if dict.name == dictName
				first = 0
				dict.each_key do |attribName|
					if first == 0 
						json += '"' + attribName + '":"' + escapeChars(dict[attribName].to_s) + '"';
						first = 1;
					else
						json += ',"' + attribName + '":"' + escapeChars(dict[attribName].to_s) + '"';
					end
                end
			end
        end
    end
    json += '}';
    json.gsub!(/,/,"#COMMA#");
	puts json;
    return json;
end

def getUniqueComponents()
	comps = Sketchup.active_model.active_entities.find_all { |group| group.typename == "ComponentInstance"}	# Get all components enteties
	uniqueComps = []
	puts "Comps: " + comps.length.to_s
	comps.each { |comp|
		if getFileName(comp) != "sl_iv_car"
			if (comp.definition.get_attribute 'sl_iv_ide', 'modelName') != nil 
				found = false
				uniqueComps.each { |uniq|
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

def escapeChars(s)
    s.gsub('"','\\\\\\"').gsub("'","\\\\'");
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