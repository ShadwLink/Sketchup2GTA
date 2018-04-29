require "shadowlink_iv_exporter/drawable/iv_drawable_exporter"
require "shadowlink_iv_exporter/drawable/v_drawable_exporter"
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
    else
      IVDrawableExporter.new()
    end
  end

end