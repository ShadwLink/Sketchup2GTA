using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwGeometryList: RwSection
    {
        public RwGeometryList() : base(0x1A)
        {
            AddStructSection();
        }
        
        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write(1);
        }
    }
}