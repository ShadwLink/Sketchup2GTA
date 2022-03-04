class PluginSettings

  SETTINGS = 'sl_gta'
  SETTING_GAME_VERSION = 'game_version'
  SETTING_SKETCHUP2GTA_PATH = 'sketchup2gta_path'

  def get_selected_game_version
    string_to_version(Sketchup.read_default(SETTINGS, SETTING_GAME_VERSION))
  end

  def set_selected_game_version(version)
    Sketchup.write_default(SETTINGS, SETTING_GAME_VERSION, version_to_string(version))
  end

  def set_sketchup2gta_path(path)
    Sketchup.write_default(SETTINGS, SETTING_SKETCHUP2GTA_PATH, path)
  end

  def get_sketchup2gta_path
    Sketchup.read_default(SETTINGS, SETTING_SKETCHUP2GTA_PATH)
  end

  def version_to_string(version)
    case version
    when :GTA_VC
      "VC"
    when :GTA_V
      "V"
    when :GTA_IV
      "IV"
    else
      "IV"
    end
  end

  def string_to_version(version_string)
    case version_string
    when "VC"
      :GTA_VC
    when "V"
      :GTA_V
    when "IV"
      :GTA_IV
    else
      :GTA_IV
    end
  end

end