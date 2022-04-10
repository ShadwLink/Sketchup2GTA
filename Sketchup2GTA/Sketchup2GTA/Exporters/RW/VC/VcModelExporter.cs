using System.IO;
using Sketchup2GTA.Exporters.Model.RW;

namespace Sketchup2GTA.Exporters.RW.VC
{
    public class VcModelExporter : ModelExporter
    {
        public void Export(Data.Model.Model model, string path)
        {
            var bw = new BinaryWriter(new FileStream(path, FileMode.OpenOrCreate));
            new RwClump()
                .AddSection(
                    new RwFrameList()
                        .AddSection(
                            new RwExtension()
                                .AddSection(new RwFrame(model.Name))
                        )
                )
                .AddSection(new RwGeometryList()
                    .AddSection(new RwGeometry(model)
                        .AddSection(new RwMaterialList(model))
                        .AddSection(new RwExtension()
                            .AddSection(new RwBinMeshPLG(model))
                        )
                    )
                )
                .AddSection(new RwAtomic()
                    .AddSection(new RwExtension())
                )
                .AddSection(new RwExtension())
                .Write(bw, RwVersion.ViceCity);
            
            bw.Flush();
            bw.Close();
        }
    }
}