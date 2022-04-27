using System;
using System.IO;
using Sketchup2GTA.Data.Model;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwTexture : RwSection
    {
        public RwTexture(string textureName, RwVersion rwVersion) : base(0x06, rwVersion)
        {
            AddStructSection();
            AddSection(new RwString(textureName, rwVersion));
            AddSection(new RwString("", rwVersion));
            AddSection(new RwExtension(rwVersion));
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write((short)0x1106);
            bw.Write((short)1);
        }
    }
}