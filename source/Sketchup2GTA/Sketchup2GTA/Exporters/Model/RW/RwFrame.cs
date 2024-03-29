using System;
using System.IO;
using Sketchup2GTA.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwFrame : RwSection
    {
        private string _name;

        public RwFrame(string name, RwVersion rwVersion) : base(0x253F2FE, rwVersion)
        {
            _name = name;
        }

        protected override void WriteSectionData(BinaryWriter bw)
        {
            bw.WriteString(_name);
        }
    }
}