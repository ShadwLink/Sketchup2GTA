using System.IO;
using System.Threading;
using SketchUpNET;
using Squish;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwTextureNative : RwSection
    {
        private Texture _texture;

        public RwTextureNative(Texture texture) : base(0x15)
        {
            _texture = texture;
            AddStructSection();
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bool compress = true;
            
            int rasterFormat = 0;
            byte bitsPerPixel = 0;
            byte compression = 0;
            byte[] data;
            int fourCC = 0;
            int constantNotSoConstant = 0;
            if (compress)
            {
                var destSize = Squish.Squish.GetStorageRequirements(_texture.Width, _texture.Height, SquishFlags.kDxt1 | SquishFlags.kColourIterativeClusterFit);
                data = new byte[destSize];
                Squish.Squish.CompressImage(_texture.Data, _texture.Width, _texture.Height, data,
                    SquishFlags.kDxt1 | SquishFlags.kColourIterativeClusterFit,
                    true);

                rasterFormat = 0x200;
                bitsPerPixel = 16;
                compression = 8;
                fourCC = 0x31545844; // DXT1
                constantNotSoConstant = 9;
            }
            else
            {
                // Fix this
                var bytesPerPixel = _texture.Data.Length / (_texture.Width * _texture.Height);
                switch (bytesPerPixel)
                {
                    case 3:
                        rasterFormat = 0x600;
                        bitsPerPixel = 24;
                        break;
                    case 4:
                        rasterFormat = 0x500;
                        bitsPerPixel = 32;
                        break;
                }

                constantNotSoConstant = 8;
                data = _texture.Data;
            }

            bw.Write(constantNotSoConstant);
            bw.Write(0x1102); // Filter flags
            WriteStringWithFixedLength(bw, _texture.Name.Replace(".png", "").Replace(".bmp", ""),
                32); // Write diffuse name
            WriteStringWithFixedLength(bw, "", 32); // Write alpha name
            bw.Write(rasterFormat); //0x8200); // Raster format
            bw.Write(fourCC); //827611204); // TODO: FourCC
            bw.Write((short)_texture.Width); // Width
            bw.Write((short)_texture.Height); // Height
            bw.Write(bitsPerPixel); // Bits per pixel
            bw.Write((byte)1); // MipMap count
            bw.Write((byte)4); // Const 4
            bw.Write(compression); // Compression type
            
            bw.Write(data.Length);
            bw.Write(data);
        }

        private void WriteStringWithFixedLength(BinaryWriter bw, string value, int length)
        {
            if (value.Length > length)
            {
                throw new InvalidDataException("String is too long. String size " + value.Length + " max " + length);
            }

            int bytesWritten = 0;
            for (var i = 0; i < value.Length; i++)
            {
                bw.Write(value[i]);
                bytesWritten++;
            }

            while (bytesWritten < length)
            {
                bw.Write((byte)0);
                bytesWritten++;
            }
        }
    }
}