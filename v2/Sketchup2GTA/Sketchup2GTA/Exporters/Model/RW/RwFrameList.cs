using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwFrameList: RwSection
    {
        public RwFrameList() : base(0xE)
        {
        }

        public void Save(BinaryWriter bw)
        {
            base.Save(bw);
        }
    }
}