require 'shadowlink_iv_exporter/bounds/collision_model'

class VBoundsExporter

  def export(model_name, ent, scale, export_path)
    puts ("export collision to V")

    file_path = "#{export_path}/#{model_name}.obn"

    File.open(file_path, 'w') do |file|
      file.puts "Version 43 31"
      export_bounds(file, ent, scale)
    end
  end

  def export_bounds(file, ent, scale)
    bounds = Bounds.new(ent)
    collision_model = CollisionModel.new(ent)

    file.puts "{"
    file.puts "\tType BoundComposite"
    file.puts "\tRadius #{bounds.radius}"
    file.puts "\tAABBMax #{bounds.maxX} #{bounds.maxY} #{bounds.maxZ}"
    file.puts "\tAABBMin #{bounds.minX} #{bounds.minY} #{bounds.minZ}"
    file.puts "\tCentroid #{bounds.centerX} #{bounds.centerY} #{bounds.centerZ}"
    file.puts "\tCG #{bounds.centerX} #{bounds.centerY} #{bounds.centerZ}"

    # Hardcoded amount of children for now
    file.puts "\tChildren 1"
    file.puts "\t{"
    file.puts "\t\tphBound"
    file.puts "\t\t{"
    file.puts "\t\t\tType BoundBVH"
    file.puts "\t\t\tRadius #{bounds.radius}"
    file.puts "\t\t\tAABBMax #{bounds.maxX} #{bounds.maxY} #{bounds.maxZ}"
    file.puts "\t\t\tAABBMin #{bounds.minX} #{bounds.minY} #{bounds.minZ}"
    file.puts "\t\t\tCentroid #{bounds.centerX} #{bounds.centerY} #{bounds.centerZ}"
    file.puts "\t\t\tCG #{bounds.centerX} #{bounds.centerY} #{bounds.centerZ}"

    # Write polys
    polygons = collision_model.polygons
    file.puts "\t\t\tPolygons #{polygons.length}"
    file.puts "\t\t\t{"
    polygons.each_with_index do |poly, index|
      file.puts "\t\t\t\tTri #{index}"
      file.puts "\t\t\t\t{"
      file.puts "\t\t\t\t\tVertices #{poly.a} #{poly.b} #{poly.c}"
      file.puts "\t\t\t\t\tSiblings #{poly.sibling(0)} #{poly.sibling(1)} #{poly.sibling(2)}"
      file.puts "\t\t\t\t\tMaterialIndex #{poly.material_index}"
      file.puts "\t\t\t\t}"
    end
    file.puts "\t\t\t}"

    file.puts "\t\t\tGeometryCenter #{bounds.centerX} #{bounds.centerY} #{bounds.centerZ} #{bounds.radius}"

    # Write vertices
    vertices = collision_model.vertices
    file.puts "\t\t\tVertices #{vertices.length}"
    file.puts "\t\t\t{"
    vertices.each do |vertex|
      file.puts "\t\t\t\t#{vertex.x} #{vertex.y} #{vertex.z}"
    end
    file.puts "\t\t\t}"

    # Write vertex colors
    file.puts "\t\t\tVertexColors #{vertices.length}"
    file.puts "\t\t\t{"
    vertices.each do |vertex|
      file.puts "\t\t\t\t#{vertex.r} #{vertex.g} #{vertex.b} #{vertex.a}"
    end
    file.puts "\t\t\t}"

    # Write materials
    materials = []
    file.puts "\t\t\tMaterials #{materials.length}"
    file.puts "\t\t\t{"
    materials.each_with_index do |material, index|
      file.puts "\t\t\t\tMaterial #{index}"
      file.puts "\t\t\t\t{"
      file.puts "\t\t\t\t\tMaterialIndex 0"
      file.puts "\t\t\t\t\tProcId 48"
      file.puts "\t\t\t\t\tRoomId 0"
      file.puts "\t\t\t\t\tPedDensity 0"
      file.puts "\t\t\t\t\tPolyFlags FORMATS_EMPTY_FLAGS"
      file.puts "\t\t\t\t\tMaterialColorIndex 1"
      file.puts "\t\t\t\t}"
    end
    file.puts "\t\t\t}"

    # Write materials
    material_colors = []
    file.puts "\t\t\tMaterialColors #{material_colors.length}"
    file.puts "\t\t\t{"
    material_colors.each do |material_color|
      file.puts "\t\t\t\t#{material_color.r} #{material_color.g} #{material_color.y} #{material_color.x}"
    end
    file.puts "\t\t\t}"

    file.puts "\t\t\tMargin 0.00500000"
    file.puts "\t\t}"
    file.puts "\t}"

    # Child transforms
    file.puts "\tChildTransforms 1"
    file.puts "\t{"
    file.puts "\t\tMatrix 0"
    file.puts "\t\t{"
    file.puts "\t\t\t1.00000000 0.00000000 0.00000000"
    file.puts "\t\t\t0.00000000 1.00000000 0.00000000"
    file.puts "\t\t\t0.00000000 0.00000000 1.00000000"
    file.puts "\t\t\t0.00000000 0.00000000 0.00000000"
    file.puts "\t\t}"
    file.puts "\t}"

    # Child flags
    file.puts "\tChildFlags 1"
    file.puts "\t{"
    file.puts "\t\tItem"
    file.puts "\t\t{"
    file.puts "\t\t\tFlags1 FORMATS_EMPTY_FLAGS"
    file.puts "\t\t\tFlags2 FORMATS_EMPTY_FLAGS"
    file.puts "\t\t}"
    file.puts "\t}"

    file.puts "}"

  end

end