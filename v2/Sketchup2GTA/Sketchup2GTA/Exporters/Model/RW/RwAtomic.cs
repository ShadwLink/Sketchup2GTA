using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwAtomic : RwSection
    {
        public RwAtomic() : base(0x14)
        {
        }

        protected override void WriteSection(BinaryWriter bw)
        {
            WriteStruct(bw);
            bw.Write(0);
            bw.Write(0);
            bw.Write(5);
            bw.Write(0);
        }

        protected override uint GetSectionSize()
        {
            return 16;
        }
    }
}