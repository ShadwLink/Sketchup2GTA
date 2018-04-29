require "shadowlink_iv_exporter/drawable/iv_drawable_exporter"
require "shadowlink_iv_exporter/drawable/v_drawable_exporter"

class VersionSelection

  def initialize
    @selected_version = :GTA_IV
  end

  def set_selected_version(game)
    @selected_version = game
  end

  def get_selected_version
    @selected_version
  end

  def get_model_exporter
    if @selected_version == :GTA_IV
      IVDrawableExporter.new()
    elsif @selected_version == :GTA_V
      VDrawableExporter.new()
    end
  end

end