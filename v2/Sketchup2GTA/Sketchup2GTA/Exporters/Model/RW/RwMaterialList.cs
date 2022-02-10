using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwMaterialList: RwSection
    {
        private Data.Model.Model _model;
        
        public RwMaterialList(Data.Model.Model model) : base(0x08)
        {
            _model = model;
        }

        protected override void WriteSection(BinaryWriter bw)
        {
            WriteStruct(bw);
            bw.Write(_model.MaterialSplits.Count);
            foreach (var split in _model.MaterialSplits)
            {
                bw.Write(-1);
            }
        }

        protected override uint GetSectionSize()
        {
            return (uint)(4 + _model.MaterialSplits.Count * 4);
        }
    }
}