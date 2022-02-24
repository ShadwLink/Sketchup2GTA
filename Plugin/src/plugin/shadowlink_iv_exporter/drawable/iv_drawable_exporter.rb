require 'shadowlink_iv_exporter/utils/sl_utils.rb'

class IVDrawableExporter

  def export(model_name, ent, scale, export_path)
    materials = get_materials_for_entity(ent)
    bounds = Bounds.new(ent)

    createDir(export_path)
    odr_file_path = "#{export_path}/#{model_name}.odr"
    high_mesh_path = "#{export_path}/#{model_name}_high.mesh"

    File.open(odr_file_path, 'w') do |file|
      file.puts "Version 110 12\n"
      export_odr_header(file, materials, model_name, bounds)
    end

    File.open(high_mesh_path, 'w') do |file|
      export_mesh(ent, file, materials, bounds, scale)
    end
  end

  def export_odr_header(file, materials, model_name, bounds)
    export_shading_group(file, materials)
    export_lod_group(file, model_name, bounds)
  end

  def export_shading_group(file, materials)
    file.puts "shadinggroup\n{"
    file.puts "\tShaders " + materials.length.to_s + "\n\t{\n"
    materials.each do |material|
      file.puts "\t\tgta_default.sps " + stripTexName(material.texture.filename) + "\n"
    end
    file.puts "\t}\n"
    file.puts "}\n"
  end

  def export_lod_group(file, model_name, bounds)
    file.puts "lodgroup\n{\n"
    file.puts "\thigh 1 #{model_name}_high.mesh 0 9999.00000000\n"
    file.puts "\tmed none 9999.00000000\n"
    file.puts "\tlow none 9999.00000000\n"
    file.puts "\tvlow none 9999.00000000\n"
    file.puts "\tcenter #{bounds.centerX} #{bounds.centerY} #{bounds.centerZ}\n"
    file.puts "\tAABBMin #{bounds.minX} #{bounds.minY} #{bounds.minZ}\n"
    file.puts "\tAABBMax #{bounds.maxX} #{bounds.maxY} #{bounds.maxZ}\n"
    file.puts "\tradius #{bounds.radius}\n"
    file.puts "}\n"
  end

  def export_mesh(ent, file, materials, bounds, scale)
    file.puts "Version 11 13\n"
    file.puts "{"
    file.puts "\tSkinned 0\n"
    file.puts "\tBounds #{(materials.length + 1)}\n\t{\n"
    materials.each do |material|
      file.puts "\t\t#{bounds.centerX} #{bounds.centerY} #{bounds.centerZ} #{bounds.radius}\n"
    end
    file.puts "\t\t#{bounds.centerX} #{bounds.centerY} #{bounds.centerZ} #{bounds.radius}\n"
    file.puts "\t}\n"

    meshes = get_meshes(materials, ent)
    meshes.each do |mesh|
      file.puts "\tMtl #{meshes.index mesh}\n\t{\n"
      file.puts "\t\tPrim 0\n\t\t{\n"
      file.puts "\t\t\tIdx #{mesh.get_indices_count}\n\t\t\t{\n"
      polygon_index = 0
      cur_length = 0
      poly_line = ""
      while polygon_index < mesh.polygons.length
        if cur_length == 0
          poly_line += "\t\t\t\t"
        end
        poly_line += mesh.polygons[polygon_index].to_s + " " + mesh.polygons[polygon_index + 1].to_s + " " + mesh.polygons[polygon_index + 2].to_s + " "
        cur_length += 1
        if cur_length >= 5
          poly_line += "\n"
          cur_length = 0
        end

        polygon_index += 3
      end
      file.puts poly_line
      file.puts "\t\t\t}\n"

      #verts
      file.puts "\t\t\tVerts #{mesh.vertices.length.to_s}\n\t\t\t{\n"
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
        file.puts "\t\t\t\t#{'%.8f' % vertex_x} #{'%.8f' % vertex_y} #{'%.8f' % vertex_z} / #{'%.8f' % norm_x} #{'%.8f' % norm_y} #{'%.8f' % norm_z} / 255 255 255 255 / 0.0 0.0 0.0 0.0 / #{'%.8f' % uv_u} #{'%.8f' % uv_v} / 0.0 0.0 / 0.0 0.0 / 0.0 0.0 / 0.0 0.0 / 0.0 0.0\n"
        vertex_index += 1
      end
      file.puts "\t\t\t}\n"
      file.puts "\t\t}\n"
      file.puts "\t}\n"
    end

    file.puts "}\n"
  end

end