using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwAtomic : RwSection
    {
        public RwAtomic() : base(0x14)
        {
            AddStructSection();
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write(0);
            bw.Write(0);
            bw.Write(5);
            bw.Write(0);
        }
    }
}