def show_hash
	model = Sketchup.active_model
    selection = model.selection
	
	groupName = selection[0].name
	if groupName == ""
		groupName = selection[0].definition.name
	end
	
	hash = [getStableHash(groupName)]

	prompts = ["Hash output"]
	defaults = [hash]
	input = UI.inputbox prompts, defaults, "Hash for \"" + groupName + "\""
end

def selected_component
    ss = Sketchup.active_model.selection
	groups = ss.find_all { |group| group.typename == "ComponentInstance"}	# Get all group enteties
	return groups.length
end

def selected_groups
	ss = Sketchup.active_model.selection
	groups = ss.find_all { |group| group.typename == "Group" }
	return groups.length
end

if( not file_loaded?("sl_iv.rb") )    
    submenu = UI.menu("Plugins").add_submenu("IV Export")
	submenu.add_item("Place car") { place_car() }
	submenu.add_item("Export scene") { export_scene() }
	submenu.add_item("Export wpl") { export_wpl("D:/SL_IV/") }
end


UI.add_context_menu_handler do |menu|
	if(selected_component == 0)
		if(selected_groups == 1)
			menu.add_separator
			submenu = menu.add_submenu("AimSpit Utils")
			submenu.add_item("Center group") { centerAxis() }
		end
	elsif selected_component == 1
		menu.add_separator
		submenu = menu.add_submenu("IV Export")
		submenu.add_item("Export Model") { export_wdr() }
		submenu.add_item("Export Collision") { export_wbn() }
		submenu.add_item("Export Textures") { export_textures() }
		submenu.add_separator
        submenu.add_item("Export WPL") { export_wpl() }
		submenu.add_item("Export IDE") { export_ide() }
		submenu.add_separator
		if(getFileName(Sketchup.active_model.selection[0]) == "sl_iv_car")
			submenu.add_item("Setup Car") { dialogCar() }
		else 
			submenu.add_item("Setup IDE") { dialogIDE() }
		end
		submenu.add_separator
		submenu.add_item("Calculate Hash") { show_hash() }
		submenu.add_item("Help") { help() }
	elsif selected_component > 1
		menu.add_separator
		submenu = menu.add_submenu("IV Export")
        submenu.add_item("Export WPL") { export_wpl() }
		submenu.add_item("Export Textures") { export_textures() }
	end
end