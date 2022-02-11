using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwClump : RwSection
    {
        public RwClump() : base(0x10)
        {
            AddStructSection();
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write((uint)1); // Object count
            bw.Write((uint)0); // Unknown
            bw.Write((uint)0); // Unknown
        }
    }
}