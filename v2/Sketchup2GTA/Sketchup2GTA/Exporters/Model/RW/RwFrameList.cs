using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwFrameList: RwSection
    {
        public RwFrameList() : base(0xE)
        {
        }

        protected override void WriteSection(BinaryWriter bw)
        {
            WriteStruct(bw);
            bw.Write((uint)1); // Frame count
            // Frame matrix
            // Row 1
            bw.Write(1f);
            bw.Write(0f);
            bw.Write(0f);
            // Row 2
            bw.Write(0f);
            bw.Write(1f);
            bw.Write(0f);
            // Row 3
            bw.Write(0f);
            bw.Write(0f);
            bw.Write(1f);
            // Position
            bw.Write(0f);
            bw.Write(0f);
            bw.Write(0f);
            // Parent frame
            bw.Write(0xFFFFFFFF);
            bw.Write(0);
        }

        protected override uint GetSectionSize()
        {
            return 60;
        }
    }
}