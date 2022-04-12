using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwGeometryList: RwSection
    {
        public RwGeometryList(RwVersion rwVersion) : base(0x1A, rwVersion)
        {
            AddStructSection();
        }
        
        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write(1);
        }
    }
}