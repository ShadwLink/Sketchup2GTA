using System;
using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwFrame : RwSection
    {
        private string _name;

        public RwFrame(string name) : base(0x253F2FE)
        {
            _name = name;
        }

        protected override void WriteSection(BinaryWriter bw)
        {
            for (int i = 0; i < _name.Length; i++)
            {
                bw.Write(_name[i]);
            }
        }
    }
}