using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwFrameList: RwSection
    {
        public RwFrameList(RwVersion rwVersion) : base(0xE, rwVersion)
        {
            AddStructSection();
        }
        
        protected override void WriteStructSection(BinaryWriter bw)
        {
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
    }
}