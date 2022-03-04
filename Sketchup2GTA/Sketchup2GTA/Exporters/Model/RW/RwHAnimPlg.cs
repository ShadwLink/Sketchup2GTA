using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwHAnimPlg: RwSection
    {
        public RwHAnimPlg() : base(0x11E)
        {
        }

        protected override void WriteSectionData(BinaryWriter bw)
        {
            bw.Write(256);
            bw.Write(-1);
            bw.Write(0);
        }
    }
}