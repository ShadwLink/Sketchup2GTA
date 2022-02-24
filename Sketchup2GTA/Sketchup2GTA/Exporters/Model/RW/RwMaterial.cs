using System.IO;
using Sketchup2GTA.Data.Model;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwMaterial: RwSection
    {
        private MaterialSplit _materialSplit;
        
        public RwMaterial(MaterialSplit materialSplit) : base(0x07)
        {
            _materialSplit = materialSplit;
            
            AddStructSection();
            AddSection(new RwTexture(materialSplit));
            AddSection(new RwExtension());
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write(0);
            bw.Write(_materialSplit.Material.MaterialColor.r);
            bw.Write(_materialSplit.Material.MaterialColor.g);
            bw.Write(_materialSplit.Material.MaterialColor.b);
            bw.Write(_materialSplit.Material.MaterialColor.a);
            bw.Write(1521788);
            bw.Write(1); // TODO: Texture count, always 1 for now
            bw.Write(1f);
            bw.Write(0f);
            bw.Write(1f);
        }
    }
}