require 'shadowlink_gta_exporter/utils/sl_utils.rb'

class VDrawableExporter

  def export(model_name, ent, scale, export_path)
    materials = get_materials_for_entity(ent)
    bounds = Bounds.new(ent)

    createDir(export_path)
    odr_file_path = "#{export_path}/#{model_name}.odr"
    high_mesh_path = "#{export_path}/#{model_name}_high.mesh"

    File.open(odr_file_path, 'w') do |file|
      file.puts "Version 165 31\n"
      export_odr_header(file, materials, model_name, bounds)
    end

    File.open(high_mesh_path, 'w') do |file|
      export_mesh(ent, file, materials, bounds, scale)
    end
  end

  def export_odr_header(file, materials, model_name, bounds)
    file.puts "{"
    export_shading_group(file, materials)
    export_skeleton(file)
    export_lod_group(file, model_name, bounds)
    export_joints(file)
    export_light(file)
    export_bound(file)
    file.puts "}\n"
  end

  def export_shading_group(file, materials)
    file.puts "\tShaders\n"
    file.puts "\t{\n"
    materials.each do |material|
      file.puts "\t\tdefault.sps\n"
      file.puts "\t\t{"
      file.puts "\t\t\tDiffuseSampler #{stripTexName(material.texture.filename)}\n"
      file.puts "\t\t\tHardAlphaBlend 1.00000000\n"
      file.puts "\t\t\tUseTessellation 0.00000000\n"
      file.puts "\t\t}"
    end
    file.puts "\t}\n"
  end

  def export_skeleton(file)
    file.puts "\tSkeleton null"
  end

  def export_lod_group(file, model_name, bounds)
    file.puts "\tLodGroup\n"
    file.puts "\t{\n"
    file.puts "\t\tCenter #{bounds.centerX} #{bounds.centerY} #{bounds.centerZ}\n"
    file.puts "\t\tRadius #{bounds.radius}\n"
    file.puts "\t\tAABBMin #{bounds.minX} #{bounds.minY} #{bounds.minZ}\n"
    file.puts "\t\tAABBMax #{bounds.maxX} #{bounds.maxY} #{bounds.maxZ}\n"
    file.puts "\t\tHigh 9998.00000000\n"
    file.puts "\t\t{\n"
    file.puts "\t\t\t#{model_name}_high.mesh 0\n"
    file.puts "\t\t}\n"
    file.puts "\t\tMed 9998.00000000\n"
    file.puts "\t\tLow 9998.00000000\n"
    file.puts "\t\tVlow 9998.00000000\n"
    file.puts "\t}\n"
  end

  def export_joints(file)
    file.puts("\tJoints null")
  end

  def export_light(file)
    file.puts("\tLight null")
  end

  def export_bound(file)
    file.puts("\tBound null")
  end

  def export_mesh(ent, file, materials, bounds, scale)
    file.puts "Version 165 31"
    file.puts "{"
    file.puts "\tLocked False"
    file.puts "\tSkinned False"
    file.puts "\tBoneCount 0"
    file.puts "\tMask 255"

    # Export bound info
    file.puts "\tBounds"
    file.puts "\t{"
    file.puts "\t\tAabb"
    file.puts "\t\t{"
    file.puts "\t\t\tMin #{bounds.minX} #{bounds.minY} #{bounds.minZ}"
    file.puts "\t\t\tMax #{bounds.maxX} #{bounds.maxY} #{bounds.maxZ}"
    file.puts "\t\t}"
    file.puts "\t}"

    # Export geometries
    file.puts "\tGeometries"
    file.puts "\t{"

    meshes = get_meshes(materials, ent)
    meshes.each do |mesh|
      file.puts "\t\tGeometry"
      file.puts "\t\t{"
      file.puts "\t\t\tShaderIndex #{meshes.index mesh}"
      file.puts "\t\t\tFlags -"
      file.puts "\t\t\tVertexDeclaration N209731BE"
      file.puts "\t\t\tIndices #{mesh.get_indices_count}"
      file.puts "\t\t\t{"

      # TODO: Rewrite this in a more readable way
      polygon_index = 0
      cur_length = 0
      poly_line = ""
      while polygon_index < mesh.polygons.length
        if cur_length == 0
          poly_line += "\t\t\t\t"
        end
        poly_line += "#{mesh.polygons[polygon_index]} #{mesh.polygons[polygon_index + 1]} #{mesh.polygons[polygon_index + 2]}"
        cur_length += 1
        if cur_length >= 5
          poly_line += "\n"
          cur_length = 0
        end

        polygon_index += 3
      end
      file.puts poly_line

      file.puts "\t\t\t}"
      file.puts "\t\t\tVertices #{mesh.vertices.length}"
      file.puts "\t\t\t{"
      vertex_index = 0
      mesh.vertices.each do |vertex|
        vertex_x = vertex.x * 0.0254 * scale
        vertex_y = vertex.y * 0.0254 * scale
        vertex_z = vertex.z * 0.0254 * scale
        norm_x = mesh.normals[vertex_index].x
        norm_y = mesh.normals[vertex_index].y
        norm_z = mesh.normals[vertex_index].z
        uv_u = mesh.uvs[vertex_index].x
        uv_v = mesh.uvs[vertex_index].y
        file.puts "\t\t\t\t#{'%.8f' % vertex_x} #{'%.8f' % vertex_y} #{'%.8f' % vertex_z} / #{'%.8f' % norm_x} #{'%.8f' % norm_y} #{'%.8f' % norm_z} / 255 255 255 255 / #{'%.8f' % uv_u} #{'%.8f' % uv_v}"
        vertex_index += 1
      end
      file.puts "\t\t\t}"
      file.puts "\t\t}"
    end
    file.puts "\t}"
    file.puts "}"
  end

end