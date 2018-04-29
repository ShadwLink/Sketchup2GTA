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
    DrawableExporter.new()
  end

end