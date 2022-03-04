using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwMaterialList: RwSection
    {
        private Data.Model.Model _model;
        
        public RwMaterialList(Data.Model.Model model) : base(0x08)
        {
            _model = model;
            AddStructSection();
            foreach (var materialSplit in _model.MaterialSplits)
            {
                AddSection(new RwMaterial(materialSplit.Material));
            }
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write(_model.MaterialSplits.Count);
            foreach (var unused in _model.MaterialSplits)
            {
                bw.Write(-1);
            }
        }
    }
}