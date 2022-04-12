using System.IO;
using Sketchup2GTA.Exporters.Model.RW;

namespace Sketchup2GTA.Exporters.RW
{
    public class RwModelExporter : ModelExporter
    {
        private RwVersion _rwVersion;

        public RwModelExporter(RwVersion rwVersion)
        {
            _rwVersion = rwVersion;
        }
        
        public void Export(Data.Model.Model model, string path)
        {
            var bw = new BinaryWriter(new FileStream(path, FileMode.OpenOrCreate));
            new RwClump(_rwVersion)
                .AddSection(
                    new RwFrameList(_rwVersion)
                        .AddSection(
                            new RwExtension(_rwVersion)
                                .AddSection(new RwFrame(model.Name, _rwVersion))
                        )
                )
                .AddSection(new RwGeometryList(_rwVersion)
                    .AddSection(new RwGeometry(model, _rwVersion)
                        .AddSection(new RwMaterialList(model, _rwVersion))
                        .AddSection(new RwExtension(_rwVersion)
                            .AddSection(new RwBinMeshPLG(_rwVersion, model))
                        )
                    )
                )
                .AddSection(new RwAtomic(_rwVersion)
                    .AddSection(new RwExtension(_rwVersion))
                )
                .AddSection(new RwExtension(_rwVersion))
                .Write(bw);
            
            bw.Flush();
            bw.Close();
        }
    }
}