def export_wbn
	puts "Exporting wbd"
	
	gtaScale = GetScale()
	
	entities = Sketchup.active_model.selection
	fileName = getFileName(entities[0])
	filePath = UI.savepanel "Save OBD File", "", fileName + ".obd"
	
	# Retrieve vertex and facecount
	vertexCount = 0					# Keeps track of vertex count
	triCount = 0					# Keeps track of triangle count
	
	materials = []
	
	# fuck the purge_unused function apparently that's not perfect, so here is a custom one
	faces = entities[0].definition.entities.find_all { |e| e.typename == "Face"}	# Get all face enteties
	faces.each do |face|									# For each face
		if face.material != nil
			matIndex = materials.index face.material
			unless matIndex		# Check if this material is already in the array
				materials.push(face.material)
			end
		end
	end
	
	verts = []				# Array that keeps track of the verts
	polyArray = []				# Array that keeps track of the polys
	polyMaterials = []		# Array that keeps track of the poly materials
	
	faces = entities[0].definition.entities.find_all { |e| e.typename == "Face"}	# Get all face enteties
	faces.each do |face|									# For each face
		mesh = face.mesh 5								# Create a trimesh of the face
				
		polys = mesh.polygons							# Get all the polygons of this face
				
		points = mesh.points							# Get all vertices of this mesh
				
		points.each do |p|								# For each vertice in this mesh
			vertIndex = verts.index p					# Check if this vertice is already in the mesh
				
			unless vertIndex							# If it's not in the mesh
				verts.push(p)							# Add it to the vertice array
				#puts "Vert: " + (p.x * 0.0254).to_s + ", " + (p.y * 0.0254).to_s + ", " + (p.z * 0.0254).to_s
			end
		end
		
		polys.each do |poly|							# For all polys
		
			if poly[0] < 0
				poly[0] *= -1
			end
			if poly[1] < 0
				poly[1] *= -1
			end
			if poly[2] < 0
				poly[2] *= -1
			end
			
			poly[0] -= 1
			poly[1] -= 1
			poly[2] -= 1
			
			pointTest1 = points[poly[0]]
			pointTest2 = points[poly[1]]
			pointTest3 = points[poly[2]]

			p1 = verts.index pointTest1
			p2 = verts.index pointTest2
			p3 = verts.index pointTest3
			
			newPoly = Array.new(3)
			newPoly[0] = p1
			newPoly[1] = p2
			newPoly[2] = p3
			polyArray.push(newPoly)
		end
	end
	# Print face vert count
	vertexCount = verts.length
	triCount = polyArray.length
	
	bounds = getBoundsMinMax(verts)
	center = getBoundsCenterMinMax(bounds)	# Get center bounds
	scale = getVertexScaleMinMax(bounds)
	
	xd = bounds[3] - center[0]
	yd = bounds[4] - center[1]
	zd = bounds[5] - center[2]
	radius = Math.sqrt(xd*xd + yd*yd + zd*zd)
	
	puts "Got vertex scale " + scale[0].to_s + ", " + scale[1].to_s + ", " + scale[2].to_s
	
	# Create a new file and write to it  
	File.open(filePath, 'w') do |f|  
		# use "\n" for two lines of text  
		f.puts "Version 32 11\n"
		f.puts "{"
		f.puts "\tphBound " + fileName + "\n" # 0 should be id
		f.puts "\t{\n"
		f.puts "\t\tType BoundBVH\n"
		f.puts "\t\tCentroidPresent 1\n"
		f.puts "\t\tCGPresent 1\n"
		f.puts "\t\tRadius " + radius.to_s + "\n"
		f.puts "\t\tWorldRadius " + radius.to_s + "\n"
		f.puts "\t\tAABBMax " + bounds[3].to_s + " " + bounds[4].to_s + " " + bounds[5].to_s + "\n"
		f.puts "\t\tAABBMin " + bounds[0].to_s + " " + bounds[1].to_s + " " + bounds[2].to_s + "\n"
		f.puts "\t\tCentroid 0.0 0.0 0.0\n"
		f.puts "\t\tCenterOfMass 0.0 0.0 0.0\n"
		f.puts "\t\tMargin 0.005 0.005 0.005\n"
		f.puts "\t\tPolygons " + triCount.to_s + "\n" # polygon count
		f.puts "\t\t{\n"
		polyID = 0
		polyArray.each do |poly|
			f.puts "\t\t\tPolygon " + polyID.to_s + "\n" #ID
			f.puts "\t\t\t{\n"
			f.puts "\t\t\t\tMaterial 0\n"
			f.puts "\t\t\t\tVertices " + poly[0].to_s + " " + poly[1].to_s + " " + poly[2].to_s + " 0 \n"
			#puts "POLY: " + poly[0].to_s + " " + poly[1].to_s + " " + poly[2].to_s
			f.puts "\t\t\t\tSiblings -1 -1 -1 -1\n"
			f.puts "\t\t\t}\n"
			polyID += 1
		end
		f.puts "\t\t}\n"
		f.puts "\t\tVertexScale " + scale[0].to_s + " " + scale[1].to_s + " " + scale[2].to_s + "\n"
		f.puts "\t\tVertexOffset 0.0 0.0 0.0\n"
		f.puts "\t\tVertices " + vertexCount.to_s + "\n" # Vertex count
		f.puts "\t\t{\n"
		verts.each do |vert|
			vertexX = vert.x * 0.0254 * gtaScale / scale[0]
			vertexY = vert.y * 0.0254 * gtaScale / scale[1]
			vertexZ = vert.z * 0.0254 * gtaScale / scale[2]
			if(vertexX.nan?)
				vertexX = 0;
			end
			if(vertexY.nan?)
				vertexY = 0;
			end
			if(vertexZ.nan?)
				vertexZ = 0;
			end
			vertX = vertexX.to_i
			vertY = vertexY.to_i
			vertZ = vertexZ.to_i
			f.puts "\t\t\t" + vertX.to_s + " " + vertY.to_s + " " + vertZ.to_s + "\n"
		end
		f.puts "\t\t}\n"
		f.puts "\t\tMaterials 1\n" # material count
		f.puts "\t\t{\n"
		#foreachmaterialcount
		f.puts "\t\t\t3 0 0\n"
		f.puts "\t\t}\n"
		f.puts "\t}\n"
		f.puts "}"
	end
	
	UI.messagebox("Export finished")
end

def export_all	
	entities = Sketchup.active_model.selection
	
	UI.messagebox("Exporting model: " + entities[0].typename)
	UI.messagebox("La: " + entities[0].definition.entities.count.to_s)
	faces = entities[0].definition.entities.find_all { |e| e.typename == "Face"}
	
	Sketchup.active_model.active_entities.each { |e|
		if e.material==nil
			Sketchup.active_model.selection.add(e) 
		end
	}
	
	UI.messagebox("FaceCount: " + faces.length.to_s)
	entities[0].definition.entities.each do |ent|
		UI.messagebox("Ent: " + ent.typename)
	end
end

def export_ide
	puts "Exporting ide"
	
	entities = Sketchup.active_model.selection

	model = Sketchup.active_model
	
	fileName = getFileName(entities[0])
	filePath = UI.savepanel "Save IDE File", "", model.title + ".ide"
	
	verts = []				# Array that keeps track of the verts
	polyArray = []				# Array that keeps track of the polys
	polyMaterials = []		# Array that keeps track of the poly materials
	
	prompts = ["Model Name"]
	defaults = [fileName]
	input = UI.inputbox prompts, defaults, "Ok"
	modelName = input[0]
	
	prompts = ["WTD Name"]
	defaults = [fileName]
	input = UI.inputbox prompts, defaults, "Ok"
	wtdName = input[0]
	
	faces = entities[0].definition.entities.find_all { |e| e.typename == "Face"}	# Get all face enteties
	faces.each do |face|									# For each face
		mesh = face.mesh 5								# Create a trimesh of the face
				
		polys = mesh.polygons							# Get all the polygons of this face
				
		points = mesh.points							# Get all vertices of this mesh
				
		points.each do |p|								# For each vertice in this mesh
			vertIndex = verts.index p					# Check if this vertice is already in the mesh
				
			unless vertIndex							# If it's not in the mesh
				verts.push(p)							# Add it to the vertice array
			end
		end
	end
	
	minmax = getBoundsMinMax(verts)	# Get max bounds
	center = getBoundsCenterMinMax(minmax)	# Get center bounds
	
	xd = minmax[3] - center[0]
	yd = minmax[4] - center[1]
	zd = minmax[5] - center[2]
	distance = Math.sqrt(xd*xd + yd*yd + zd*zd)
	
	if File::exists?( filePath )
		File.open(filePath, 'r') do |old|
			File.open(filePath + ".tmp", 'w') do |new|
				line = old.gets
				while(line != "end\n")
					new.puts line
					line = old.gets
				end
				new.puts modelName + ", " + wtdName + ", 300.0, 0, 0, " + minmax[0].to_s + ", " + minmax[1].to_s + ", " + minmax[2].to_s + ", " + minmax[3].to_s + ", " + minmax[4].to_s + ", " + minmax[5].to_s + ", " + center[0].to_s + ", " + center[1].to_s + ", " + center[2].to_s + ", " + distance.to_s + ", null\n"
				new.puts "end\n"
				while(line = old.gets) 
					new.puts line
				end
			end
		end	
		File.delete(filePath)
		File.rename(filePath + ".tmp", filePath)
	else
		File.open(filePath, 'w') do |new|
			new.puts "objs\n"
			new.puts modelName + ", " + wtdName + ", 300.0, 0, 0, " + minmax[0].to_s + ", " + minmax[1].to_s + ", " + minmax[2].to_s + ", " + minmax[3].to_s + ", " + minmax[4].to_s + ", " + minmax[5].to_s + ", " + center[0].to_s + ", " + center[1].to_s + ", " + center[2].to_s + ", " + distance.to_s + ", null\n"
			new.puts "end\ntobj\nend\ntree\nend\npath\nend\nanim\nend\ntanm\nend\nmlo\nend\n2dfx\nend\ntxdp\nend\n"
		end
	end
	
	UI.messagebox("Export finished")
end

def export_wdr
	scale = GetScale()
	
	entities = Sketchup.active_model.selection
	fileName = getFileName(entities[0])
	filePath = UI.savepanel "Save ODR File", "", fileName + ".odr"

	materials = []
	
	# fuck the purge_unused function apparently that's not perfect, so here is a custom one
	faces = entities[0].definition.entities.find_all { |e| e.typename == "Face"}	# Get all face enteties
	faces.each do |face|									# For each face
		if face.material != nil
			matIndex = materials.index face.material
			unless matIndex		# Check if this material is already in the array
				materials.push(face.material)
			end
		end
	end
	
	nullTerm = 0					# used to write the zero after a null term string
	meshCount = 1					# Model count
	geoCount = [materials.length] 	# Geometry count
	name = "test"					# model name
	currentMat = [0]				# the current materialID
	
	vertexCount = 0					# Keeps track of vertex count
	triCount = 0					# Keeps track of triangle count
	
	# First thing we want to do here is create an array of all vertices
	verts = []				# Array that keeps track of the verts
	polyArray = []			# Array that keeps track of the polys
	polyMaterials = []		# Array that keeps track of the poly materials
	
	faces = entities[0].definition.entities.find_all { |e| e.typename == "Face"}	# Get all face enteties
	faces.each do |face|									# For each face
		mesh = face.mesh 5								# Create a trimesh of the face
				
		polys = mesh.polygons							# Get all the polygons of this face
				
		points = mesh.points							# Get all vertices of this mesh
				
		points.each do |p|								# For each vertice in this mesh
			vertIndex = verts.index p					# Check if this vertice is already in the mesh
				
			unless vertIndex							# If it's not in the mesh
				verts.push(p)							# Add it to the vertice array
			end
		end
	end
	
	minmax = getBoundsMinMax(verts)		# Get max bounds
	center = getBoundsCenterMinMax(minmax)	# Get center bounds

	xd = minmax[3] - center[0]
	yd = minmax[4] - center[1]
	zd = minmax[5] - center[2]
	distance = Math.sqrt(xd*xd + yd*yd + zd*zd)
	
	
	# Create a new file and write to it  
	File.open(filePath, 'w') do |f|  
		f.puts "Version 110 12\n" 	# version
		f.puts "shadinggroup\n{"	# shading group
		f.puts "\tShaders " + materials.length.to_s + "\n\t{\n"
		materials.each do |mat|		# Split the model up per material
			f.puts "\t\tgta_default.sps " + stripTexName(mat.texture.filename) + "\n"
		end
		f.puts "\t}\n"
		f.puts "}\n"
		f.puts "lodgroup\n{\n"
		f.puts "\thigh 1 " + fileName + "_high.mesh 0 9999.00000000\n"
		f.puts "\tmed none 9999.00000000\n"
		f.puts "\tlow none 9999.00000000\n"
		f.puts "\tvlow none 9999.00000000\n"
		f.puts "\tcenter " + center[0].to_s + " " + center[1].to_s + " " + center[2].to_s + "\n"
		f.puts "\tAABBMin " + minmax[0].to_s + " " + minmax[1].to_s + " " + minmax[2].to_s + "\n"
		f.puts "\tAABBMax " + minmax[3].to_s + " " + minmax[4].to_s + " " + minmax[5].to_s + "\n"
		f.puts "\tradius " + distance.to_s + "\n"
		f.puts "}\n"
	end
	
	File.open(filePath[0,filePath.length-4] + '_high.mesh', 'w') do |f|  
		f.puts "Version 11 12\n" 	# version
		f.puts "{"	# shading group
		f.puts "\tSkinned 0\n"
		f.puts "\tBounds " + (materials.length + 1).to_s + "\n\t{\n"
		materials.each do |mat|		# Split the model up per material
			# TODO: Should be per material bounds
			f.puts "\t\t" + center[0].to_s + " " + center[1].to_s + " " + center[2].to_s + " " + distance.to_s + "\n"
		end
		f.puts "\t\t" + center[0].to_s + " " + center[1].to_s + " " + center[2].to_s + " " + distance.to_s + "\n"
		f.puts "\t}\n"
		count = 0
		materials.each do |mat|		# Split the model up per material
		
			# This is where we collect the needed data		
			verts = []				# Array that keeps track of the verts
			uvs	  = [] 				# Array that keeps track of the verts uv coords
			normals = []			# Array that keeps track of the verts normals
			polyArray = []			# Array that keeps track of the polys
			
			vertCount = [0]			# The amount of vertices (This one is incorrect)
			faceCount = [0]			# The amount of faces (Correct)
			
			curVertexCount = 0
			
			faces = entities[0].definition.entities.find_all { |e| e.typename == "Face"}	# Get all face enteties
			faces.each do |face|									# For each face
				if face.material == mat								# Check if the face uses this split material
				
					mesh = face.mesh 5								# Create a trimesh of the face
					
					polys = mesh.polygons							# Get all the polygons of this face
					
					points = mesh.points							# Get all vertices of this mesh
					
					pointIndex = 1
					points.each do |p|								# For each vertice in this mesh
						vertIndex = verts.index p					# Check if this vertice is already in the mesh
						
						uv = mesh.uv_at(pointIndex,true)			# Get the UV map of the front face
						normal = mesh.normal_at pointIndex			# Get the normal
						pointIndex += 1								# Increase the current point index
						
						
						verts.push(p)							# Add it to the vertice array
						uvs.push(uv)							# Add it to the UV array
						normals.push(normal)
					end
					
					polys.each do |poly|							# For all polys
						if poly[0] < 0
							poly[0] *= -1
						end
						if poly[1] < 0
							poly[1] *= -1
						end
						if poly[2] < 0
							poly[2] *= -1
						end
						p1 = poly[0] - 1 + curVertexCount
						p2 = poly[1] - 1 + curVertexCount
						p3 = poly[2] - 1 + curVertexCount
						
						polyArray.push(p1)#value1)
						polyArray.push(p2)#value2)
						polyArray.push(p3)#value3)
					end
					faceCount[0] += polys.length					# Increase the facecount
					curVertexCount += points.length
				end
			end
			
			# Print face vert count
			vertCount[0] = verts.length
		
			f.puts "\tMtl " + count.to_s + "\n\t{\n"	# TODO: Add index
			f.puts "\t\tPrim 0\n\t\t{\n"
			f.puts "\t\t\tIdx " + (faceCount[0] * 3).to_s + "\n\t\t\t{\n" # TODO: Add index count
			test = 0
			curLength = 0
			polyLine = ""
			while test < polyArray.length
				if curLength == 0
					polyLine += "\t\t\t\t"
				end
				polyLine += polyArray[test].to_s + " " + polyArray[test + 1].to_s + " " + polyArray[test + 2].to_s + " "
				curLength += 1
				if curLength >= 5
					polyLine += "\n"
					curLength = 0
				end
				
				test += 3
			end
			f.puts polyLine
			f.puts "\t\t\t}\n"
			
			#verts
			f.puts "\t\t\tVerts " + verts.length.to_s + "\n\t\t\t{\n" # TODO: Add vert count
			iVertIndex = 0
			verts.each do |vert|
				vertexX = [vert.x * 0.0254 * scale]
				vertexY = [vert.y * 0.0254 * scale]
				vertexZ = [vert.z * 0.0254 * scale]
				normX = [normals[iVertIndex].x]
				normY = [normals[iVertIndex].y]
				normZ = [normals[iVertIndex].z]
				uvU = [uvs[iVertIndex].x * 1]
				uvV = [uvs[iVertIndex].y * -1]
				f.puts "\t\t\t\t" + vertexX.to_s + " " + vertexY.to_s + " " + vertexZ.to_s + " / " + normX.to_s + " " + normY.to_s + " " + normZ.to_s + " / 255 255 255 255 / 0.0 0.0 0.0 / " + uvU.to_s + " " + uvV.to_s + " / 0.0 0.0 / 0.0 0.0 / 0.0 0.0 / 0.0 0.0 / 0.0 0.0\n"				
				iVertIndex += 1
			end
			f.puts "\t\t\t}\n"
			f.puts "\t\t}\n"
			f.puts "\t}\n"
			count += 1
		end
		f.puts "}\n"
	end
	
	UI.messagebox("Export finished")
	puts "Export finished"
end

def export_textures
	puts "Exporting tex"
	
	texDir = UI.savepanel "Select texture directory", "", "tex"
	texDir = texDir[0, texDir.length - 3]			# Remove the extension
	
	tw = Sketchup.create_texture_writer
	# Get everything that is selected
	entities = Sketchup.active_model.selection
	
	materials = []
	
	# fuck the purge_unused function apparently that's not perfect, so here is a custom one
	faces = entities[0].definition.entities.find_all { |e| e.typename == "Face"}	# Get all face enteties
	faces.each do |face|									# For each face
		if face.material != nil
			matIndex = materials.index face.material
			unless matIndex		# Check if this material is already in the array
				materials.push(face.material)
			end
		end
	end
	
	materials.each do |mat|
		matDone = false
		faces = entities[0].definition.entities.find_all { |e| e.typename == "Face"}	# Get all face enteties
		faces.each do |face|
			if matDone == false
				if face.material == mat
					puts texDir + stripTexName(face.material.texture.filename) + ".png"
					tw.load face, true
					return_val = tw.write(face, true, texDir + stripTexName(face.material.texture.filename) + ".png")
					matDone = true
				end
			end
		end
	end
	
	puts "TWCount: " + tw.count.to_s
	
	UI.messagebox("Export finished")
end

def export_wpl	
	model = Sketchup.active_model
    selection = model.selection

	model = Sketchup.active_model
	filePath = UI.savepanel "Save WPL File", "", model.title + ".wpl"
	
	groups = selection.find_all { |group| group.typename == "ComponentInstance"}	# Get all group enteties
	
	scale = GetScale()
	
	fileHeader = 	[3]				# the current fileHeader
	instCount = 	[groups.length]	# the current instance count
	unused1 = 		[0]				# the current materialID
	garaCount = 	[0]				# the current materialID
	carsCount = 	[0]				# the current materialID
	cullCount = 	[0]				# the current materialID
	unused2 = 		[0]				# the current materialID
	unused3 = 		[0]				# the current materialID
	unused4 = 		[0]				# the current materialID
	strbCount = 	[0]				# the current materialID
	lodcCount =		[0]
	zoneCount = 	[0]
	unused5 =		[0]
	unused6 =		[0]
	unused7 =		[0]
	unused8	=		[0]
	blokCount =		[0]
	
	File.open(filePath, "wb") { |f|
		f.write fileHeader.pack("I")
		f.write instCount.pack("I")
		f.write unused1.pack("I")
		f.write garaCount.pack("I")
		f.write carsCount.pack("I")
		f.write cullCount.pack("I")
		f.write unused2.pack("I")
		f.write unused3.pack("I")
		f.write unused4.pack("I")
		f.write strbCount.pack("I")
		f.write lodcCount.pack("I")
		f.write zoneCount.pack("I")
		f.write unused5.pack("I")
		f.write unused6.pack("I")
		f.write unused7.pack("I")
		f.write unused8.pack("I")
		f.write blokCount.pack("I")
	
		groups.each do |g|
			
			groupName = getFileName(g)
			
			hash = [getStableHash(groupName)]
			a = g.transformation.origin.to_a
			posX = [a[0] * 0.0254 * scale] 
			posY = [a[1] * 0.0254 * scale] 
			posZ = [a[2] * 0.0254 * scale] 
			
			m00 = g.transformation.xaxis[0]
			m01 = g.transformation.xaxis[1]
			m02 = g.transformation.xaxis[2]
			m10 = g.transformation.yaxis[0]
			m11 = g.transformation.yaxis[1]
			m12 = g.transformation.yaxis[2]
			m20 = g.transformation.zaxis[0]
			m21 = g.transformation.zaxis[1]
			m22 = g.transformation.zaxis[2]
			
			############################################
			tr = m00 + m11 + m22
			
			if tr > 0
				sq = Math.sqrt(tr+1.0) * 2; # S=4*qw 
				qw = 0.25 * sq;
				qx = (m21 - m12) / sq;
				qy = (m02 - m20) / sq; 
				qz = (m10 - m01) / sq; 
			elsif (m00 > m11)&(m00 > m22)
				sq = Math.sqrt(1.0 + m00 - m11 - m22) * 2; # S=4*qx 
				qw = (m21 - m12) / sq;
				qx = 0.25 * sq;
				qy = (m01 + m10) / sq; 
				qz = (m02 + m20) / sq; 
			elsif m11 > m22
				sq = Math.sqrt(1.0 + m11 - m00 - m22) * 2; # S=4*qy
				qw = (m02 - m20) / sq;
				qx = (m01 + m10) / sq; 
				qy = 0.25 * sq;
				qz = (m12 + m21) / sq; 
			else
				sq = Math.sqrt(1.0 + m22 - m00 - m11) * 2; # S=4*qz
				qw = (m10 - m01) / sq;
				qx = (m02 + m20) / sq;
				qy = (m12 + m21) / sq;
				qz = 0.25 * sq;
			end
			
			rotX = [qx]
			rotY = [qy]
			rotZ = [qz]
			rotW = [qw]
			
			unk1 = [0]
			lodI = [-1]
			unk2 = [0]
			unk3 = [0]
		
			# Write all instance values
			f.write posX.pack("F")
			f.write posY.pack("F")
			f.write posZ.pack("F")
			f.write rotX.pack("F")
			f.write rotY.pack("F")
			f.write rotZ.pack("F")
			f.write rotW.pack("F")
			f.write hash.pack("I")
			f.write unk1.pack("I")
			f.write lodI.pack("I")
			f.write unk2.pack("I")
			f.write unk3.pack("I")
		end
	}
	UI.messagebox("Done exporting WPL")
end