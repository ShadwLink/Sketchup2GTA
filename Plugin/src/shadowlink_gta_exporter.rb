require 'sketchup.rb'
require 'extensions.rb'

module ShadowLink
  module Sketchup2GTA

    unless file_loaded?(__FILE__)
      ex = SketchupExtension.new('Sketchup2GTA', 'shadowlink_gta_exporter/main')
      ex.description = 'GTA exporter for Sketchup'
      ex.version     = '0.6.0'
      ex.creator     = 'Shadow-Link'
      Sketchup.register_extension(ex, true)
      file_loaded(__FILE__)
    end

  end
end