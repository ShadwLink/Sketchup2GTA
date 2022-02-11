using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwString : RwSection
    {
        private string _value;

        public RwString(string value) : base(0x02)
        {
            _value = value;
        }

        protected override void WriteSection(BinaryWriter bw)
        {
            for (int i = 0; i < _value.Length; i++)
            {
                bw.Write(_value[i]);
            }

            bw.Write((byte)0);
        }

        protected override uint GetSectionSize()
        {
            return (uint)_value.Length + 1;
        }
    }
}