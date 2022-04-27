using System.IO;
using Sketchup2GTA.Data.Model;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwMaterial : RwSection
    {
        private Material _material;

        public RwMaterial(Material material, RwVersion rwVersion) : base(0x07, rwVersion)
        {
            _material = material;

            AddStructSection();
            if (material.HasTexture())
            {
                AddSection(new RwTexture(material.TextureName, rwVersion));
            }

            AddSection(new RwExtension(rwVersion));
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write(0);
            bw.Write(_material.MaterialColor.r);
            bw.Write(_material.MaterialColor.g);
            bw.Write(_material.MaterialColor.b);
            bw.Write(_material.MaterialColor.a);
            bw.Write(1521788);
            bw.Write(GetTextureCount());
            bw.Write(1f);
            bw.Write(0f);
            bw.Write(1f);
        }

        private int GetTextureCount()
        {
            // TODO: Move to material?
            return _material.HasTexture() ? 1 : 0;
        }
    }
}