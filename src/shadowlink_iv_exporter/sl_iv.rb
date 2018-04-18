Sketchup.load('shadowlink_iv_exporter/wpl/wpl_exporter.rb')
Sketchup.load('shadowlink_iv_exporter/textures/texture_exporter.rb')
Sketchup.load('shadowlink_iv_exporter/scene/scene_exporter.rb')
Sketchup.load('shadowlink_iv_exporter/ide/ide_exporter.rb')
Sketchup.load('shadowlink_iv_exporter/drawable/drawable_exporter.rb')
Sketchup.load('shadowlink_iv_exporter/bounds/bounds_exporter.rb')
Sketchup.load('shadowlink_iv_exporter/selection/SelectionDialog.rb')
Sketchup.load('shadowlink_iv_exporter/drawable/drawable_dictionary_exporter.rb')

MAX_DECIMALS = 8

def selected_component
  ss = Sketchup.active_model.selection
  groups = ss.find_all {|group| group.typename == "ComponentInstance"} # Get all group enteties
  return groups.length
end

def get_selected_components
  Sketchup.active_model.selection.find_all {|group| group.typename == "ComponentInstance"}
end

def selected_groups
  ss = Sketchup.active_model.selection
  groups = ss.find_all {|group| group.typename == "Group"}
  return groups.length
end

if (not file_loaded?("sl_iv.rb"))
  submenu = UI.menu("Plugins").add_submenu("IV Export")
  submenu.add_item("Place car") {place_car}
  submenu.add_item("Export scene") {save_scene}
  submenu.add_item("Export wpl") {save_wpl}
  submenu.add_separator
  submenu.add_item("Help") {show_help}
end

UI.add_context_menu_handler do |menu|
  if selected_component == 0
    if selected_groups == 1
      menu.add_separator
      submenu = menu.add_submenu("AimSpit Utils")
      submenu.add_item("Center group") {centerAxis}
    end
  elsif selected_component == 1
    menu.add_separator
    submenu = menu.add_submenu("IV Export")

    submenu.add_item("Export Model") {save_model}
    submenu.add_item("Export Collision") {save_collision}
    submenu.add_item("Export Textures") {save_textures}

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
    submenu.add_item("Export Textures") {save_textures}
  end
end

def save_model
  selection = get_selected_components[0]
  model_name = selection.definition.get_attribute 'sl_iv_ide', 'modelName'
  output_path = UI.savepanel("Export location", nil, "#{model_name}.odr")

  if output_path
    model_name = File.basename(output_path, ".*")
    output_dir = File.dirname(output_path)
    export_odr(model_name, selection, GetScale(), output_dir)
  end
end

def save_odd
  selection = get_selected_components
  output_path = UI.savepanel("Export location", nil, "")

  if output_path
    odd_name = File.basename(output_path, ".*")
    output_dir = File.dirname(output_path)
    exporter = DrawableDictionaryExporter.new
    exporter.export(odd_name, output_dir, selection)
  end
end

def save_collision
  selection = get_selected_components[0]
  model_name = selection.definition.get_attribute 'sl_iv_ide', 'modelName'
  output_path = UI.savepanel("Export location", nil, "#{model_name}.obd")

  if output_path
    model_name = File.basename(output_path, ".*")
    output_dir = File.dirname(output_path)
    export_obn(model_name, selection, GetScale(), output_dir)
  end
end

def save_wpl
  output_dir = UI.select_directory(title: "Select Output Directory")
  export_wpl(output_dir)
end

def save_ide
  output_dir = UI.select_directory(title: "Select Output Directory")
  export_ide(get_selected_components, output_dir)
end

def save_textures
  output_dir = UI.select_directory(title: "Select Output Directory")
  export_entities_textures(get_selected_components, output_dir)
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
  input = UI.inputbox prompts, defaults, "Hash for \"" + groupName + "\""
end