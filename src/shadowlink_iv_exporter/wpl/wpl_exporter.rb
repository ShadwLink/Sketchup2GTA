require 'logger'

def export_wpl(exportPath)
  filePath = "#{exportPath}/#{Sketchup.active_model.title}.wpl"

  puts "Exporting WPL #{filePath}"

  instances = []
  cars = []
  components = Sketchup.active_model.active_entities.find_all {|group| group.typename == "ComponentInstance"} # Get all components enteties
  components.each do |comp|
    if getFileName(comp) != "sl_iv_car"
      instances.push comp
    else
      cars.push comp
    end
  end

  scale = GetScale()

  fileHeader = [3] # the current fileHeader
  instCount = [instances.length] # the current instance count
  unused1 = [0] #
  garaCount = [0] # the garagecount
  carsCount = [cars.length] # the Car count
  cullCount = [0] #
  unused2 = [0] #
  unused3 = [0] #
  unused4 = [0] #
  strbCount = [0] #
  lodcCount = [0]
  zoneCount = [0]
  unused5 = [0]
  unused6 = [0]
  unused7 = [0]
  unused8 = [0]
  blokCount = [0]

  File.open(filePath, "wb") {|f|
    f.write fileHeader.pack("I")
    f.write instCount.pack("I")
    f.write unused1.pack("I")
    f.write garaCount.pack("I")
    f.write carsCount.pack("I")
    f.write cullCount.pack("I")
    f.write unused2.pack("I")
    f.write unused3.pack("I")
    f.write unused4.pack("I")
    f.write strbCount.pack("I")
    f.write lodcCount.pack("I")
    f.write zoneCount.pack("I")
    f.write unused5.pack("I")
    f.write unused6.pack("I")
    f.write unused7.pack("I")
    f.write unused8.pack("I")
    f.write blokCount.pack("I")

    # Export instances
    instances.each do |g|

      groupName = getFileName(g)

      hash = [getStableHash(groupName)]
      a = g.transformation.origin.to_a
      posX = [a[0] * 0.0254 * scale]
      posY = [a[1] * 0.0254 * scale]
      posZ = [a[2] * 0.0254 * scale]

      m00 = g.transformation.xaxis[0]
      m01 = g.transformation.xaxis[1]
      m02 = g.transformation.xaxis[2]
      m10 = g.transformation.yaxis[0]
      m11 = g.transformation.yaxis[1]
      m12 = g.transformation.yaxis[2]
      m20 = g.transformation.zaxis[0]
      m21 = g.transformation.zaxis[1]
      m22 = g.transformation.zaxis[2]

      ############################################
      tr = m00 + m11 + m22

      if tr > 0
        sq = Math.sqrt(tr + 1.0) * 2; # S=4*qw
        qw = 0.25 * sq;
        qx = (m21 - m12) / sq;
        qy = (m02 - m20) / sq;
        qz = (m10 - m01) / sq;
      elsif (m00 > m11) & (m00 > m22)
        sq = Math.sqrt(1.0 + m00 - m11 - m22) * 2; # S=4*qx
        qw = (m21 - m12) / sq;
        qx = 0.25 * sq;
        qy = (m01 + m10) / sq;
        qz = (m02 + m20) / sq;
      elsif m11 > m22
        sq = Math.sqrt(1.0 + m11 - m00 - m22) * 2; # S=4*qy
        qw = (m02 - m20) / sq;
        qx = (m01 + m10) / sq;
        qy = 0.25 * sq;
        qz = (m12 + m21) / sq;
      else
        sq = Math.sqrt(1.0 + m22 - m00 - m11) * 2; # S=4*qz
        qw = (m10 - m01) / sq;
        qx = (m02 + m20) / sq;
        qy = (m12 + m21) / sq;
        qz = 0.25 * sq;
      end

      rotX = [qx]
      rotY = [qy]
      rotZ = [qz]
      rotW = [qw]

      unk1 = [0]
      lodI = [-1]
      unk2 = [0]
      unk3 = [0]

      # Write all instance values
      f.write posX.pack("F")
      f.write posY.pack("F")
      f.write posZ.pack("F")
      f.write rotX.pack("F")
      f.write rotY.pack("F")
      f.write rotZ.pack("F")
      f.write rotW.pack("F")
      f.write hash.pack("I")
      f.write unk1.pack("I")
      f.write lodI.pack("I")
      f.write unk2.pack("I")
      f.write unk3.pack("I")
    end

    # Export cars
    cars.each do |car|
      a = car.transformation.origin.to_a
      posX = [a[0] * 0.0254 * scale]
      posY = [a[1] * 0.0254 * scale]
      posZ = [a[2] * 0.0254 * scale]
      rotX = [7]
      rotY = [2.19742E-006]
      rotZ = [3]
      hash = [getCarHash(car)]
      color1 = [-1]
      color2 = [-1]
      color3 = [-1]
      color4 = [-1]
      flags = [1633]
      alarm = [0]
      unknown = [0]

      f.write posX.pack("F")
      f.write posY.pack("F")
      f.write posZ.pack("F")
      f.write rotX.pack("F")
      f.write rotY.pack("F")
      f.write rotZ.pack("F")
      f.write hash.pack("I")
      f.write color1.pack("I")
      f.write color2.pack("I")
      f.write color3.pack("I")
      f.write color4.pack("I")
      f.write flags.pack("I")
      f.write alarm.pack("I")
      f.write unknown.pack("I")
    end
  }
end