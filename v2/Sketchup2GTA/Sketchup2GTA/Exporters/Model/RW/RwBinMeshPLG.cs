using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwBinMeshPLG : RwSection
    {
        private Data.Model.Model _model;

        public RwBinMeshPLG(Data.Model.Model model) : base(0x50E)
        {
            _model = model;
        }

        protected override void WriteSection(BinaryWriter bw)
        {
            bw.Write(0); // Is tri-strip
            bw.Write(_model.MaterialSplits.Count);
            bw.Write(_model.GetTotalFaceCount());
            for (var index = 0; index < _model.MaterialSplits.Count; index++)
            {
                var split = _model.MaterialSplits[index];
                bw.Write(split.Indices.Count);
                bw.Write(index);
                foreach (var faceIndex in split.Indices)
                {
                    bw.Write((ushort)faceIndex);
                }
            }
        }
    }
}