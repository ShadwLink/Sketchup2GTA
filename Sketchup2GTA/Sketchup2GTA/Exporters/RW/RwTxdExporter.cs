using System.IO;
using Sketchup2GTA.Data;
using Sketchup2GTA.Exporters.Model.RW;

namespace Sketchup2GTA.Exporters.RW
{
    public class RwTxdExporter : TextureDictionaryExporter
    {
        private RwVersion _rwVersion;

        public RwTxdExporter(RwVersion rwVersion)
        {
            _rwVersion = rwVersion;
        }

        public void Export(TextureDictionary dictionary, string path)
        {
            var bwTxd = new BinaryWriter(new FileStream(path, FileMode.OpenOrCreate));

            new RwTextureDictionary(dictionary.Textures, _rwVersion)
                .Write(bwTxd);

            bwTxd.Flush();
            bwTxd.Dispose();
        }
    }
}