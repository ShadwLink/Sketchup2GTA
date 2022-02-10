using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwGeometryList: RwSection
    {
        public RwGeometryList() : base(0x1A)
        {
        }

        protected override void WriteSection(BinaryWriter bw)
        {
            WriteStruct(bw);
            bw.Write(1);
        }

        protected override uint GetSectionSize()
        {
            return 4;
        }
    }
}