using System.IO;
using Sketchup2GTA.Data.Model;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwMaterial: RwSection
    {
        public RwMaterial(MaterialSplit materialSplit) : base(0x07)
        {
            AddStructSection();
            AddSection(new RwTexture(materialSplit));
            AddSection(new RwExtension());
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write(0);
            bw.Write(0xFFFFFFFF); // TODO: RGBA Color
            bw.Write(1521788);
            bw.Write(1); // Texture count, always 1 for now
            bw.Write(1f);
            bw.Write(0f);
            bw.Write(1f);
        }
    }
}