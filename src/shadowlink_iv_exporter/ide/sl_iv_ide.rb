def initComponentIDE
	entities = Sketchup.active_model.selection
	comp = entities[0]
	comp_def = comp.definition
	
	comp_def.set_attribute 'sl_iv_ide', 'modelName', getFileName(comp)
	comp_def.set_attribute 'sl_iv_ide', 'wtdName', getFileName(comp)
	comp_def.set_attribute 'sl_iv_ide', 'drawDist', '300'
	comp_def.set_attribute 'sl_iv_ide', 'ideName', (Sketchup.active_model.title + ".ide")
end

def dialogIDE
	entities = Sketchup.active_model.selection
	comp = entities[0]
	comp_def = comp.definition
	
	# Check if the model name has been set in attributes, if not initialize it
	checkName = comp_def.get_attribute 'sl_iv_ide', 'modelName'
	puts checkName
	if checkName == nil
		initComponentIDE()
	end
	
	modelName = getFileName(comp)
	
	html_path = Sketchup.find_support_file "ide.html" ,"Plugins/SL_IV_Export/views/"
	dlg = UI::WebDialog.new("IDE Settings", false, "ShowSketchUpDotCom", 300, 300, 300, 300, false);
	dlg.set_url html_path
	dlg.add_action_callback("applyIDEValues") { |web_dialog, json| applyIDEValues(comp, json); dlg.close() }
	dlg.show {
		dlg.execute_script("initIDEValues('" + getJSONDictionarie(Sketchup.active_model.selection[0], "sl_iv_ide") + "')");
	}
end

def showTestDialog
	html_path = File.join(__dir__, 'ide.html')
	puts "html path: " + html_path

	dialog = UI::HtmlDialog.new(
			{
					:dialog_title => "IDE Settings",
					:preferences_key => "com.sample.plugin",
					:style => UI::HtmlDialog::STYLE_DIALOG
			})
	dialog.set_url(html_path)
	dialog.show
end

def applyIDEValues(ent, jsonIDE)
	comp_def = ent.definition
	hash_ide = eval( jsonIDE )
	comp_def.set_attribute 'sl_iv_ide', 'ideName', hash_ide['ideName']
	comp_def.set_attribute 'sl_iv_ide', 'modelName', hash_ide['modelName']
	comp_def.set_attribute 'sl_iv_ide', 'wtdName', hash_ide['wtdName']
	comp_def.set_attribute 'sl_iv_ide', 'drawDist', hash_ide['drawDist']
end

def cancelIDEDialog
	puts "Cancel IDE"
end