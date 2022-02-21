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

        protected override void WriteSectionData(BinaryWriter bw)
        {
            foreach (var c in _value)
            {
                bw.Write(c);
            }

            bw.Write((byte)0);
        }
    }
}