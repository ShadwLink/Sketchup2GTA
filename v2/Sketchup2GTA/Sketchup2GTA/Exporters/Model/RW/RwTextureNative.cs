using System.IO;
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

        private static bool IsTextureCompressable(Texture texture)
        {
            return IsPowerOfTwo(texture.Width) && IsPowerOfTwo(texture.Height);
        }

        private static bool IsPowerOfTwo(int number)
        {
            if (number == 0)
                return false;

            while (number != 1)
            {
                if (number % 2 != 0)
                    return false;

                number /= 2;
            }

            return true;
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bool compress = IsTextureCompressable(_texture);

            var bytesPerPixel = _texture.Data.Length / (_texture.Width * _texture.Height);

            RasterFormat rasterFormat = RasterFormat.RASTER_8888;
            byte bitsPerPixel = 0;
            byte compressionType = 0;
            byte[] data;
            int fourCC = 0;
            int constantNotSoConstant = 0;

            if (compress)
            {
                byte[] bitmapData = bytesPerPixel == 3 ? ToRgba(_texture.Data) : _texture.Data;

                var destSize = Squish.Squish.GetStorageRequirements(_texture.Width, _texture.Height,
                    SquishFlags.kDxt1 | SquishFlags.kColourIterativeClusterFit);
                data = new byte[destSize];
                Squish.Squish.CompressImage(bitmapData, _texture.Width, _texture.Height, data,
                    SquishFlags.kDxt1 | SquishFlags.kColourIterativeClusterFit,
                    true);

                rasterFormat = RasterFormat.RASTER_565;
                bitsPerPixel = 16;
                compressionType = 1;
                fourCC = 0; //0x31545844; // 'DXT1'
                constantNotSoConstant = 8; // Sometimes 9 sometimes 8?
            }
            else
            {
                switch (bytesPerPixel)
                {
                    case 3:
                        rasterFormat = RasterFormat.RASTER_888;
                        bitsPerPixel = 24;
                        break;
                    case 4:
                        rasterFormat = RasterFormat.RASTER_8888;
                        bitsPerPixel = 32;
                        break;
                }

                constantNotSoConstant = 8;
                data = _texture.Data;
            }

            bw.Write(constantNotSoConstant);
            bw.Write(0x1102); // Filter flags
            WriteStringWithFixedLength(bw, _texture.Name.Replace(".png", "").Replace(".bmp", ""),
                32); // Diffuse name
            WriteStringWithFixedLength(bw, "", 32); // Alpha name
            bw.Write((int)rasterFormat);
            bw.Write(fourCC); // TODO: FourCC
            bw.Write((short)_texture.Width);
            bw.Write((short)_texture.Height);
            bw.Write(bitsPerPixel);
            bw.Write((byte)1); // MipMap count
            bw.Write((byte)4); // Const 4
            bw.Write(compressionType);

            bw.Write(data.Length);
            bw.Write(data);
        }

        private byte[] ToRgba(byte[] rgb)
        {
            byte[] bitmapData = new byte[rgb.Length + (rgb.Length / 3)];
            int byteIndex = 0;
            for (var i = 0; i < rgb.Length; i += 3)
            {
                bitmapData[byteIndex] = rgb[i + 2];
                byteIndex++;
                bitmapData[byteIndex] = rgb[i + 1];
                byteIndex++;
                bitmapData[byteIndex] = rgb[i];
                byteIndex++;

                if ((i + 3) % 3 == 0)
                {
                    bitmapData[byteIndex] = 0xff;
                    byteIndex++;
                }
            }

            return bitmapData;
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

        private enum RasterFormat
        {
            RASTER_565 = 0x200,
            RASTER_8888 = 0x500,
            RASTER_888 = 0x600,
        }
    }
}