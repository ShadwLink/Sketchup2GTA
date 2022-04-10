using System.IO;
using Sketchup2GTA.Data;
using Sketchup2GTA.Exporters.Model.RW;

namespace Sketchup2GTA.Exporters.RW.VC
{
    public class VcTxdExporter: TextureDictionaryExporter
    {
        public void Export(TextureDictionary dictionary, string path)
        {
            var bwTxd = new BinaryWriter(new FileStream(path, FileMode.OpenOrCreate));

            new RwTextureDictionary(dictionary.Textures)
                .Write(bwTxd, RwVersion.ViceCity);

            bwTxd.Flush();
            bwTxd.Dispose();
        }
    }
}