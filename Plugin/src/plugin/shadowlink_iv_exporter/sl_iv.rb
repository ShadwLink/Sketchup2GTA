require 'shadowlink_iv_exporter/version_selection.rb'
require 'shadowlink_iv_exporter/plugin_settings.rb'

Sketchup.load('shadowlink_iv_exporter/wpl/wpl_exporter.rb')
Sketchup.load('shadowlink_iv_exporter/scene/scene_exporter.rb')
Sketchup.load('shadowlink_iv_exporter/ide/ide_exporter.rb')
Sketchup.load('shadowlink_iv_exporter/selection/SelectionDialog.rb')
Sketchup.load('shadowlink_iv_exporter/drawable/drawable_dictionary_exporter.rb')
Sketchup.load('shadowlink_iv_exporter/bounds/bounds_dictionary_exporter.rb')

MAX_DECIMALS = 8

@version_selection = VersionSelection.new(PluginSettings.new())

def selected_component
  ss = Sketchup.active_model.selection
  groups = ss.find_all {|group| group.typename == "ComponentInstance"} # Get all group enteties
  return groups.length
end

def get_selected_components
  Sketchup.active_model.selection.find_all {|group| group.typename == "ComponentInstance"}
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
  groups = ss.find_all {|group| group.typename == "Group"}
  return groups.length
end

if (not file_loaded?("sl_iv.rb"))
  placement_submenu = UI.menu("Plugins").add_submenu("GTA Export")
  placement_submenu.add_item("Place car") {place_car}
  placement_submenu.add_item("Export scene") {save_scene}
  placement_submenu.add_item("Export wpl") {save_wpl}
  placement_submenu.add_separator
  placement_submenu.add_item("Help") {show_help}

  version_submenu = UI.menu("Plugins").add_submenu("GTA Version")
  iv_item = version_submenu.add_item("IV") {@version_selection.set_selected_version(:GTA_IV)}
  version_submenu.set_validation_proc(iv_item) {
    if @version_selection.get_selected_version == :GTA_IV
      MF_CHECKED
    else
      MF_UNCHECKED
    end
  }

  v_item = version_submenu.add_item("V") {@version_selection.set_selected_version(:GTA_V)}
  version_submenu.set_validation_proc(v_item) {
    if @version_selection.get_selected_version == :GTA_V
      MF_CHECKED
    else
      MF_UNCHECKED
    end
  }
end

UI.add_context_menu_handler do |menu|
  if selected_component == 1
    menu.add_separator
    submenu = menu.add_submenu("GTA Export")

    submenu.add_item("Export ODR") {save_model}
    submenu.add_item("Export OBN") {save_collision}
    submenu.add_item("Export OTD") {save_textures}

    submenu.add_separator
    if (getFileName(Sketchup.active_model.selection[0]) == "sl_iv_car")
      submenu.add_item("Setup Car") {dialogCar}
    else
      submenu.add_item("Setup IDE") {SelectionDialog.new()}
    end

    submenu.add_separator
    submenu.add_item("Calculate Hash") {show_hash}

  elsif selected_component > 1
    menu.add_separator
    submenu = menu.add_submenu("IV Export")
    submenu.add_item("Export WPL") {save_wpl}
    submenu.add_item("Export IDE") {save_ide}
    submenu.add_item("Export ODD") {save_odd}
    submenu.add_item("Export OBD") {save_obd}
    submenu.add_item("Export OTD") {save_textures}
  end
end

def save_model
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

def save_collision
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

def save_wpl
  if @version_selection.get_selected_version == :GTA_IV
    selection = get_selected_components
    output_path = UI.savepanel("Export location", nil, "#{Sketchup.active_model.title}.wpl")

    if output_path
      wpl_name = File.basename(output_path, ".*")
      output_dir = File.dirname(output_path)
      export_wpl(selection, output_dir, wpl_name)
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

def save_textures
  texture_exporter = @version_selection.get_texture_exporter
  output_dir = UI.select_directory(title: "Select Output Directory")
  texture_exporter.export(get_selected_components, output_dir)
end

def save_scene
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