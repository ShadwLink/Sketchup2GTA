require 'erb'

class IDEDialog < Sketchup::SelectionObserver

  def initialize
    Sketchup.active_model.selection.add_observer(self)

    options = {
        :dialog_title => "Selection Settings",
        :preferences_key => "nl.shadow-link.selection",
        :style => UI::HtmlDialog::STYLE_DIALOG
    }
    @dialog = UI::HtmlDialog.new(options)
    @dialog.add_action_callback("setIDEName") do |action_context, value|
      @selection.definition.set_attribute 'sl_iv_ide', 'ideName', value
    end
    @dialog.add_action_callback("setModelName") do |action_context, value|
      @selection.definition.set_attribute 'sl_iv_ide', 'modelName', value
    end
    @dialog.add_action_callback("setTextureName") do |action_context, value|
      @selection.definition.set_attribute 'sl_iv_ide', 'textureName', value
    end
    @dialog.add_action_callback("setDrawDistance") do |action_context, value|
      @selection.definition.set_attribute 'sl_iv_ide', 'drawDist', value
    end
    @dialog.center
    @dialog.show

    updateDialog(Sketchup.active_model.selection)
  end

  def onSelectionBulkChange(selection)
    updateDialog(selection)
  end

  def onSelectionCleared(selection)
    updateDialog(selection)
  end

  def updateDialog(selection)
    if selection.length == 0
      html_output = "Nothing selected"
    elsif selection.length > 1
      html_output = "Multiple items selected"
    else
      @selection = selection[0]
      @ide_name = @selection.definition.get_attribute 'sl_iv_ide', 'ideName'
      @model_name = @selection.definition.get_attribute 'sl_iv_ide', 'modelName'
      @texture_name = @selection.definition.get_attribute 'sl_iv_ide', 'textureName'
      @draw_distance = @selection.definition.get_attribute 'sl_iv_ide', 'drawDist'

      html_file = File.join(__dir__, '', 'ide.html')
      html_output = ERB.new(File.read(html_file)).result(binding)
    end

    @dialog.set_html(html_output)
  end

end