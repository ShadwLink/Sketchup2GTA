using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwStruct : RwSection
    {
        private byte[] _data;

        public RwStruct(byte[] data, RwVersion rwVersion) : base(0x01, rwVersion)
        {
            _data = data;
        }

        protected override void WriteSectionData(BinaryWriter bw)
        {
            bw.Write(_data);
        }
    }
}