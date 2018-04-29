require "shadowlink_iv_exporter/drawable/iv_drawable_exporter"
require "shadowlink_iv_exporter/drawable/v_drawable_exporter"
require "shadowlink_iv_exporter/textures/iv_texture_exporter"
require "shadowlink_iv_exporter/textures/v_texture_exporter"
require "shadowlink_iv_exporter/bounds/iv_bounds_exporter"
require "shadowlink_iv_exporter/bounds/v_bounds_exporter"
require "shadowlink_iv_exporter/plugin_settings"

class VersionSelection

  def initialize(plugin_settings)
    @plugin_settings = plugin_settings
  end

  def set_selected_version(game)
    @plugin_settings.set_selected_game_version(game)
  end

  def get_selected_version
    @plugin_settings.get_selected_game_version
  end

  def get_model_exporter
    case get_selected_version
    when :GTA_IV
      IVDrawableExporter.new()
    when :GTA_V
      VDrawableExporter.new()
    end
  end

  def get_texture_exporter
    case get_selected_version
    when :GTA_IV
      IVTextureExporter.new()
    when :GTA_V
      VTextureExporter.new()
    end
  end

  def get_collision_exporter
    case get_selected_version
    when :GTA_IV
      IVBoundsExporter.new()
    when :GTA_V
      VBoundsExporter.new()
    end
  end

end