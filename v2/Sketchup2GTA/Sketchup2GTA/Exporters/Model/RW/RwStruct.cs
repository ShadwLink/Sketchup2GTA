using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwStruct : RwSection
    {
        private byte[] _data;

        public RwStruct(byte[] data) : base(0x01)
        {
            _data = data;
        }

        protected override void WriteSection(BinaryWriter bw)
        {
            bw.Write(_data);
        }

        protected override uint GetSectionSize()
        {
            return (uint)_data.Length;
        }
    }
}