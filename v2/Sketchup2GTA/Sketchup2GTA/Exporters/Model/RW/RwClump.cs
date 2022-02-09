using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwClump : RwSection
    {
        public RwClump() : base(0x10)
        {
        }

        public void Save(BinaryWriter bw)
        {
            base.Save(bw);
        }
    }
}