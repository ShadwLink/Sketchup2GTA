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
    when :GTA_III
      "III"
    when :GTA_VC
      "VC"
    when :GTA_SA
      "SA"
    when :GTA_IV
      "IV"
    when :GTA_V
      "V"
    else
      "VC"
    end
  end

  def string_to_version(version_string)
    case version_string
    when "III"
      :GTA_III
    when "VC"
      :GTA_VC
    when "SA"
      :GTA_SA
    when "IV"
      :GTA_IV
    when "V"
      :GTA_V
    else
      :GTA_VC
    end
  end

end