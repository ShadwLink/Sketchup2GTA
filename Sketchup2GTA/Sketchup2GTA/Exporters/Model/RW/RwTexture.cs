using System;
using System.IO;
using Sketchup2GTA.Data.Model;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwTexture : RwSection
    {
        public RwTexture(string textureName) : base(0x06)
        {
            AddStructSection();
            AddSection(new RwString(textureName));
            AddSection(new RwString(""));
            AddSection(new RwExtension());
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write((short)0x1106);
            bw.Write((short)1);
        }
    }
}