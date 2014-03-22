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
	
	return bounds
end

# Get the bounding box max
def getBoundsMax( verts )
	max = Array.new(3)
	
	max[0] = verts[0].x
	max[1] = verts[0].y
	max[2] = verts[0].z
	
	verts.each do |vert|
		if vert.x > max[0] 
			max[0] = vert.x
		end
		if vert.y > max[1]
			max[1] = vert.y
		end
		if vert.z > max[2]
			max[2] = vert.z
		end
	end
	
	max[0] *= 0.0254
	max[1] *= 0.0254
	max[2] *= 0.0254
	
	max[0] *= GetScale()
	max[1] *= GetScale()
	max[2] *= GetScale()
	puts "Max: " + max[0].to_s + " " + max[1].to_s + " " + max[2].to_s
	
	return max
end

# Get the bounding box max
def getBoundsMin( verts )
	min = Array.new(3)
	
	min[0] = verts[0].x
	min[1] = verts[0].y
	min[2] = verts[0].z
	
	verts.each do |vert|
		if vert.x < min[0] 
			min[0] = vert.x
		end
		if vert.y < min[1]
			min[1] = vert.y
		end
		if vert.z < min[2]
			min[2] = vert.z
		end
	end
	
	min[0] *= 0.0254
	min[1] *= 0.0254
	min[2] *= 0.0254
	min[0] *= GetScale()
	min[1] *= GetScale()
	min[2] *= GetScale()
	puts "min: " + min[0].to_s + " " + min[1].to_s + " " + min[2].to_s
	
	return min
end

# Get the bounding box max
def getBoundsCenter( min, max )
	center = Array.new(3)
	
	center[0] = (min[0] + max[0]) / 2
	center[1] = (min[1] + max[1]) / 2
	center[2] = (min[2] + max[2]) / 2
	
	return center
end

# Get the bounding box max
def getBoundsCenterMinMax( minmax )
	center = Array.new(3)
	
	center[0] = (minmax[0] + minmax[3]) / 2
	center[1] = (minmax[1] + minmax[4]) / 2
	center[2] = (minmax[2] + minmax[5]) / 2
	
	return center
end

# Get the vertex scale
def getVertexScale( min, max )
	scale = Array.new(3)
	
	num = max[0] / 32767;
	num2 = min[0] / -32768;
	if num > num2
		scale[0] = num
	else
		scale[0] = num2
	end
	
	num = max[1] / 32767;
	num2 = min[1] / -32768;
	if num > num2
		scale[1] = num
	else
		scale[1] = num2
	end
	
	num = max[2] / 32767;
	num2 = min[2] / -32768;
	if num > num2
		scale[2] = num
	else
		scale[2] = num2
	end
	
	return scale
end

# Returns vertex scale 
def getVertexScaleMinMax( minmax )
	scale = Array.new(3)
	
	num = minmax[3] / 32767;
	num2 = minmax[0] / -32768;
	if num > num2
		scale[0] = num
	else
		scale[0] = num2
	end
	
	num = minmax[4] / 32767;
	num2 = minmax[1] / -32768;
	if num > num2
		scale[1] = num
	else
		scale[1] = num2
	end
	
	num = minmax[5] / 32767;
	num2 = minmax[2] / -32768;
	if num > num2
		scale[2] = num
	else
		scale[2] = num2
	end
	
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
	
	puts texName
	
	return texName
end

# Checks if a string ends with a string
def ends_with(fileName, str)
	tail = fileName[fileName.length - str.length, fileName.length]
	puts "Tail: " + tail + " " + str
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
def getStableHash( string )
	string.downcase!

	# Set hash to 0
	hash = 0x00000000

	i = 0
	# Start hashing
	while( i < string.length )
		hash += string[i]
		hash += ( hash << 10 )
		hash = truncate( hash )
		hash ^= ( hash >> 6 )
		hash = truncate( hash )
		i += 1
	end

	# Final cascade
	hash += ( hash << 3 )
	hash = truncate( hash )
	hash ^= ( hash >> 11 )
	hash = truncate( hash )
	hash += ( hash << 15 )
	hash = truncate( hash )

	return ( hash )
end

def resetAxis(ent)
	model = Sketchup.active_model
	puts "Trans: " + model.edit_transform.to_s
	# Sketchup.send_action("selectAxisTool:")
	# status = model.place_component modcomp, false
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

def GetScale()
	return 1.27
end