require 'shellwords'

require 'shadowlink_gta_exporter/version_selection.rb'
require 'shadowlink_gta_exporter/plugin_settings.rb'

Sketchup.load('shadowlink_gta_exporter/wpl/wpl_exporter.rb')
Sketchup.load('shadowlink_gta_exporter/scene/scene_exporter.rb')
Sketchup.load('shadowlink_gta_exporter/ide/ide_exporter.rb')
Sketchup.load('shadowlink_gta_exporter/selection/SelectionDialog.rb')
Sketchup.load('shadowlink_gta_exporter/drawable/drawable_dictionary_exporter.rb')
Sketchup.load('shadowlink_gta_exporter/bounds/bounds_dictionary_exporter.rb')

MAX_DECIMALS = 8

@plugin_settings = PluginSettings.new
@version_selection = VersionSelection.new(@plugin_settings)

def selected_component
  ss = Sketchup.active_model.selection
  groups = ss.find_all { |group| group.typename == "ComponentInstance" } # Get all group enteties
  return groups.length
end

def get_selected_components
  Sketchup.active_model.selection.find_all { |group| group.typename == "ComponentInstance" }
end

def get_selected_unique_components
  unique_components = []
  unique_component_definitions = []
  components = get_selected_components

  components.each do |component|
    unless unique_component_definitions.index component.definition
      unique_component_definitions.push component.definition
      unique_components.push component
    end
  end

  unique_components
end

def selected_groups
  ss = Sketchup.active_model.selection
  groups = ss.find_all { |group| group.typename == "Group" }
  return groups.length
end

def add_version_menu_item(version_submenu, title, game)
  item = version_submenu.add_item(title) { @version_selection.set_selected_version(game) }
  version_submenu.set_validation_proc(item) {
    if @version_selection.get_selected_version == game
      MF_CHECKED
    else
      MF_UNCHECKED
    end
  }
end

if (not file_loaded?("sl_exporter.rb"))
  gta_exporter_submenu = UI.menu("Plugins").add_submenu("GTA Exporter")

  # Export scene
  export_placement_submenu = gta_exporter_submenu.add_submenu("Export placement")
  export_placement_submenu.add_item("Place car") { place_car }
  export_placement_submenu.add_item("Export scene") { export_scene }
  export_placement_submenu.add_item("Export placement") { export_placement }

  # Model export
  export_model_submenu = gta_exporter_submenu.add_submenu("Export model")
  export_model_submenu.add_item("Export model") { export_model(true, false, false) }
  export_model_submenu.add_item("Export textures") { export_model(false, true, false) }
  export_model_submenu.add_item("Export collision") { export_model(false, false, true) }
  export_model_submenu.add_separator
  export_model_submenu.add_item("Export all") { export_model(true, true, true) }

  # Export model

  # Settings menu
  settings_submenu = gta_exporter_submenu.add_submenu("Settings")
  version_submenu = settings_submenu.add_submenu("GTA Version")
  add_version_menu_item(version_submenu, "VC", :GTA_VC)
  add_version_menu_item(version_submenu, "IV", :GTA_IV)
  add_version_menu_item(version_submenu, "V", :GTA_V)

  settings_submenu.add_item("Sketchup2GTA Path") { select_sketchup2gta_path }

  # Help
  gta_exporter_submenu.add_item("Help") { show_help }
end

def select_sketchup2gta_path
  prompts = ["Enter path to Sketchup2GTA"]
  defaults = [@plugin_settings.get_sketchup2gta_path]
  input = UI.inputbox(prompts, defaults, "Path to Sketchup2GTA")
  path = input.first
  if File.file?(path)
    @plugin_settings.set_sketchup2gta_path(path.gsub('\\', '/'))
  else
    UI::messagebox("Invalid path to Sketchup2GTA")
  end
end

UI.add_context_menu_handler do |menu|
  if selected_component == 1
    menu.add_separator
    submenu = menu.add_submenu("GTA Export")

    submenu.add_item("Export Model") { export_selected_model }
    submenu.add_item("Export Collision") { export_collision }
    submenu.add_item("Export Textures") { export_textures }

    submenu.add_separator
    if (getFileName(Sketchup.active_model.selection[0]) == "sl_iv_car")
      submenu.add_item("Setup Car") { dialogCar }
    else
      submenu.add_item("Setup IDE") { SelectionDialog.new() }
    end

    submenu.add_separator
    submenu.add_item("Calculate Hash") { show_hash }

  elsif selected_component > 1
    menu.add_separator
    submenu = menu.add_submenu("IV Export")
    submenu.add_item("Export WPL") { export_placement }
    submenu.add_item("Export IDE") { save_ide }
    submenu.add_item("Export ODD") { save_odd }
    submenu.add_item("Export OBD") { save_obd }
    submenu.add_item("Export OTD") { export_textures }
  end
end

def export_model(exportModel, exportTextures, exportCollision)
  SKETCHUP_CONSOLE.show

  path = @plugin_settings.get_sketchup2gta_path
  if path.nil? || path.empty?
    UI::messagebox("Sketchup2GTA path not defined")
  else
    if Sketchup.active_model.save(Sketchup.active_model.path)
      gta_exporter = @plugin_settings.get_sketchup2gta_path

      input_path = Sketchup.active_model.path
      if File.file?(gta_exporter)
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

        gta_command = "'#{gta_exporter}' model -i #{input_path} #{export_command}"
        value = `#{gta_command}`
      else
        puts "GTA Exporter not configured properly"
      end
    end
  end
end

def export_selected_model
  drawable_export = @version_selection.get_model_exporter
  selection = get_selected_components[0]
  model_name = selection.definition.get_attribute 'sl_iv_ide', 'modelName'
  output_path = UI.savepanel("Export location", nil, "#{model_name}.odr")

  if output_path
    model_name = File.basename(output_path, ".*")
    output_dir = File.dirname(output_path)
    drawable_export.export(model_name, selection, GetScale(), output_dir)
  end
end

def save_odd
  if @version_selection.get_selected_version == :GTA_IV
    selection = get_selected_components
    output_path = UI.savepanel("Export location", nil, "")

    if output_path
      odd_name = File.basename(output_path, ".*")
      output_dir = File.dirname(output_path)
      exporter = DrawableDictionaryExporter.new
      exporter.export(odd_name, output_dir, selection)
    end
  else
    UI::messagebox("ODD export not supported for GTA: V")
  end
end

def save_obd
  if @version_selection.get_selected_version == :GTA_IV
    selection = get_selected_components
    output_path = UI.savepanel("Export location", nil, "")

    if output_path
      obd_name = File.basename(output_path, ".*")
      output_dir = File.dirname(output_path)
      exporter = BoundsDictionaryExporter.new
      exporter.export(obd_name, output_dir, selection)
    end
  else
    UI::messagebox("OBD export not supported for GTA: V")
  end
end

def export_collision
  if @version_selection.get_selected_version == :GTA_IV
    selection = get_selected_components[0]
    model_name = selection.definition.get_attribute 'sl_iv_ide', 'modelName'
    output_path = UI.savepanel("Export location", nil, "#{model_name}.obn")

    if output_path
      model_name = File.basename(output_path, ".*")
      output_dir = File.dirname(output_path)
      collision_exporter = @version_selection.get_collision_exporter
      collision_exporter.export(model_name, selection, GetScale(), output_dir)
    end
  else
    UI::messagebox("OBN export not supported for GTA: V")
  end
end

def export_placement
  if @version_selection.get_selected_version == :GTA_IV
    selection = get_selected_components
    output_path = UI.savepanel("Export location", nil, "#{Sketchup.active_model.title}.wpl")

    if output_path
      wpl_name = File.basename(output_path, ".*")
      output_dir = File.dirname(output_path)
      export_placement(selection, output_dir, wpl_name)
    end
  else
    UI::messagebox("WPL export not supported for GTA: V")
  end
end

def save_ide
  if @version_selection.get_selected_version == :GTA_IV
    selection = get_selected_unique_components
    output_path = UI.savepanel("Export location", nil, "#{Sketchup.active_model.title}.ide")

    if output_path
      ide_name = File.basename(output_path, ".*")
      output_dir = File.dirname(output_path)
      export_ide(selection, output_dir, ide_name)
    end
  else
    UI::messagebox("IDE export not supported for GTA: V")
  end
end

def export_textures
  texture_exporter = @version_selection.get_texture_exporter
  output_dir = UI.select_directory(title: "Select Output Directory")
  texture_exporter.export(get_selected_components, output_dir)
end

def export_scene
  output_dir = UI.select_directory(title: "Select Output Directory")
  export_scene(output_dir)
end

def show_help
  html_file = File.join(__dir__, 'help', 'help.html') # Use external HTML
  options = {
    :dialog_title => "Shadow-Link's Sketchup2IV",
    :preferences_key => "example.htmldialog.materialinspector",
    :style => UI::HtmlDialog::STYLE_DIALOG
  }
  dialog = UI::HtmlDialog.new(options)
  dialog.set_file(html_file) # Can be set here.
  dialog.center
  dialog
  dialog.show
end

def show_hash
  model = Sketchup.active_model
  selection = model.selection

  groupName = selection[0].name
  if groupName == ""
    groupName = selection[0].definition.name
  end

  hash = [getStableHash(groupName)]

  prompts = ["Hash output"]
  defaults = hash
  UI.inputbox prompts, defaults, "Hash for \"" + groupName + "\""
end