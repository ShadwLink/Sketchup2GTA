require 'sketchup.rb'
require 'extensions.rb'

module ShadowLink
  module Sketchup2IV

    unless file_loaded?(__FILE__)
      ex = SketchupExtension.new('Sketchup2IV', 'shadowlink_iv_exporter/main')
      ex.description = 'GTA IV exporter for Sketchup'
      ex.version     = '0.5.0'
      ex.copyright   = 'Shadow-Link'
      ex.creator     = 'Shadow-Link'
      Sketchup.register_extension(ex, true)
      file_loaded(__FILE__)
    end

  end # module Sketchup2IV
end # module ShadowLink