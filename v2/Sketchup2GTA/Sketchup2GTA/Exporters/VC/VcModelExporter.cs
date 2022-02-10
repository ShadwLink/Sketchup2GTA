using System.IO;
using Sketchup2GTA.Exporters.Model.RW;

namespace Sketchup2GTA.Exporters.VC
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
                                .AddSection(new RwHAnimPlg())
                                .AddSection(new RwFrame("Frame"))
                        )
                )
                .AddSection(new RwGeometryList()
                    .AddSection(new RwGeometry(model)
                        .AddSection(new RwMaterialList(model))
                    )
                )
                .AddSection(new RwAtomic())
                .AddSection(new RwExtension())
                .Write(bw);
        }
    }
}