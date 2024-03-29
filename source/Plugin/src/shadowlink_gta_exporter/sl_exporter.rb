require 'shadowlink_gta_exporter/plugin_settings.rb'

Sketchup.load('shadowlink_gta_exporter/selection/SelectionDialog.rb')

MAX_DECIMALS = 8

@plugin_settings = PluginSettings.new

def add_version_menu_item(version_submenu, title, game, is_enabled)
  item = version_submenu.add_item(title) { @plugin_settings.set_selected_game_version(game) }
  version_submenu.set_validation_proc(item) {
    if is_enabled
      if @plugin_settings.get_selected_game_version == game
        MF_CHECKED
      else
        MF_UNCHECKED
      end
    else
      MF_GRAYED
    end
  }
end

unless file_loaded?("sl_exporter.rb")
  gta_exporter_submenu = UI.menu("Plugins").add_submenu("GTA Exporter")

  # Random utils
  gta_exporter_submenu.add_item("Place car") { place_car }

  # Export scene
  export_placement_submenu = gta_exporter_submenu.add_submenu("Export placement")
  export_placement_submenu.add_item("Export scene") { export_scene }

  # Model export
  export_model_submenu = gta_exporter_submenu.add_submenu("Export model")
  export_model_submenu.add_item("Export model") { export_model(true, false, false) }
  export_model_submenu.add_item("Export textures") { export_model(false, true, false) }
  export_model_submenu.add_item("Export collision") { export_model(false, false, true) }
  export_model_submenu.add_separator
  export_model_submenu.add_item("Export all") { export_model(true, true, true) }

  # Settings menu
  settings_submenu = gta_exporter_submenu.add_submenu("Settings")
  version_submenu = settings_submenu.add_submenu("GTA Version")
  add_version_menu_item(version_submenu, "III", :GTA_III, true)
  add_version_menu_item(version_submenu, "VC", :GTA_VC, true)
  add_version_menu_item(version_submenu, "SA", :GTA_SA, true)
  add_version_menu_item(version_submenu, "IV", :GTA_IV, true)
  add_version_menu_item(version_submenu, "V", :GTA_V, false)

  settings_submenu.add_item("Sketchup2GTA Path") { select_sketchup2gta_path }

  # Help
  gta_exporter_submenu.add_item("Help") { show_help }
end

def select_sketchup2gta_path
  saved_path = @plugin_settings.get_sketchup2gta_path
  path = UI.openpanel("Select sketchup2gta.exe", saved_path, "Sketchup2GTA.exe|Sketchup2GTA.exe||")
  if !path.nil? && File.file?(path)
    @plugin_settings.set_sketchup2gta_path(path.gsub('\\', '/'))
  end
end

def export_model(exportModel, exportTextures, exportCollision)
  SKETCHUP_CONSOLE.show

  gta_exporter_path = @plugin_settings.get_sketchup2gta_path
  if gta_exporter_path.nil? || gta_exporter_path.empty? || !File.file?(gta_exporter_path)
    UI::messagebox("Sketchup2GTA path not defined")
  else
    if Sketchup.active_model.save(Sketchup.active_model.path)

      input_path = Sketchup.active_model.path

      output_path = UI.select_directory(
        title: "Select output directory",
        directory: input_path,
        select_multiple: false
      )

      export_command = "-"
      if exportModel
        export_command += "m"
      end
      if exportTextures
        export_command += "t"
      end
      if exportCollision
        export_command += "c"
      end

      gta_command = "'#{gta_exporter_path}' model -i #{input_path} #{export_command} -g #{get_game_arg} -o #{output_path}"
      value = `#{gta_command}`
    end
  end
end

def export_scene()
  SKETCHUP_CONSOLE.show

  gta_exporter_path = @plugin_settings.get_sketchup2gta_path
  if gta_exporter_path.nil? || gta_exporter_path.empty? || !File.file?(gta_exporter_path)
    UI::messagebox("Sketchup2GTA path not defined")
  else
    if Sketchup.active_model.save(Sketchup.active_model.path)
      input_path = Sketchup.active_model.path

      output_path = UI.select_directory(
        title: "Select output directory",
        directory: input_path,
        select_multiple: false
      )

      gta_command = "'#{gta_exporter_path}' map -i #{input_path} --id 641 -g #{get_game_arg} -o #{output_path}"
      value = `#{gta_command}`
    end
  end
end

def get_game_arg
  case @plugin_settings.get_selected_game_version
  when :GTA_III
    "iii"
  when :GTA_VC
    "vc"
  when :GTA_SA
    "sa"
  when :GTA_IV
    "iv"
  when :GTA_V
    "v"
  else
    "vc"
  end
end

def show_help
  html_file = File.join(__dir__, 'help', 'help.html')
  options = {
    :dialog_title => "Shadow-Link's Sketchup2GTA",
    :preferences_key => "example.htmldialog.materialinspector",
    :style => UI::HtmlDialog::STYLE_DIALOG
  }
  dialog = UI::HtmlDialog.new(options)
  dialog.set_file(html_file)
  dialog.center
  dialog
  dialog.show
end
