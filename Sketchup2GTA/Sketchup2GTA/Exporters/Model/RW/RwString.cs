using System.IO;
using Sketchup2GTA.IO;

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
            // TODO: This should just be a null terminated String
            bw.WriteString(_value);
            bw.Write((byte)0);
        }
    }
}