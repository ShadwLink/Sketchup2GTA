def dialogCar
	html_path = Sketchup.find_support_file "car.html" ,"Plugins/SL_IV_Export/views/"
	dlg = UI::WebDialog.new("Car Settings", false, "ShowSketchUpDotCom", 50, 50, 50, 50, false);
	dlg.set_url html_path
	dlg.show {
		# Do nothing yet
	}
end

def place_car
	model = Sketchup.active_model
	show_summary = true
	
	car_model_path = Sketchup.find_support_file "sl_iv_car.skp" ,"Plugins/SL_IV_Export/resources/"
	
	status = model.import car_model_path, show_summary
end