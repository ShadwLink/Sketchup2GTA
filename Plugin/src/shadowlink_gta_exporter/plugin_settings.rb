class PluginSettings

  def get_selected_game_version
    string_to_version(Sketchup.read_default('sl_gta', 'game_version'))
  end

  def set_selected_game_version(version)
    Sketchup.write_default('sl_gta', 'game_version', version_to_string(version))
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