class IDEDialog

  def initialize
    # @model = model
    # Pass to the observer the instance of this tool,
    # so that the observer can call methods of this tool.
    # observer = MySelectionObserver.new(self)
    # @model.selection.add_observer(observer)

    # Create the dialog.
    html_file = File.join(__dir__, '', 'ide.html')
    options = {
        :dialog_title => "IDE Settings",
        :preferences_key => "example.htmldialog.materialinspector",
        :style => UI::HtmlDialog::STYLE_DIALOG
    }
    @dialog = UI::HtmlDialog.new(options)
    @html = %Q{
      <html>
        <head>
        </head>
        <body>
          <br/>
          Thickness: #{Sketchup.active_model.selection[0].name}<br/>
          <br/>
        </body>
      </html>
    }

    @dialog.set_html(@html)
    @dialog.center
    @dialog
    @dialog.show
  end

  def refresh(entities)
    # Call a JavaScript method on the webdialog to accept the new data.
    # just some example data (array of strings)
    # entity_types = entities.map {|e| e.typename}.uniq
    # @dialog.execute_script('MyTool.refresh(#{entity_types.inspect})')
  end

  def initComponentIDE
    entities = Sketchup.active_model.selection
    comp = entities[0]
    comp_def = comp.definition

    comp_def.set_attribute 'sl_iv_ide', 'modelName', getFileName(comp)
    comp_def.set_attribute 'sl_iv_ide', 'wtdName', getFileName(comp)
    comp_def.set_attribute 'sl_iv_ide', 'drawDist', '300'
    comp_def.set_attribute 'sl_iv_ide', 'ideName', (Sketchup.active_model.title + ".ide")
  end

  def applyIDEValues(ent, jsonIDE)
    comp_def = ent.definition
    hash_ide = eval(jsonIDE)
    comp_def.set_attribute 'sl_iv_ide', 'ideName', hash_ide['ideName']
    comp_def.set_attribute 'sl_iv_ide', 'modelName', hash_ide['modelName']
    comp_def.set_attribute 'sl_iv_ide', 'wtdName', hash_ide['wtdName']
    comp_def.set_attribute 'sl_iv_ide', 'drawDist', hash_ide['drawDist']
  end

  def cancelIDEDialog
    puts "Cancel IDE"
  end
end