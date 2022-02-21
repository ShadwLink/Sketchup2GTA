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

        protected override void WriteSectionData(BinaryWriter bw)
        {
            foreach (var c in _name)
            {
                bw.Write(c);
            }
        }
    }
}