def dialogCar
	html_path = File.join(__dir__, 'vehicle', 'car.html')
	dlg = UI::WebDialog.new("Car Settings", false, "ShowSketchUpDotCom", 50, 50, 50, 50, false)
	dlg.set_url html_path
	dlg.show {
		# Do nothing yet
	}
end

def place_car
	model = Sketchup.active_model
	show_summary = true

	car_model_path = File.join(__dir__, 'resources', 'sl_car.skp')

	status = model.import car_model_path, show_summary
end