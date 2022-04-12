using System;
using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwBinMeshPLG : RwSection
    {
        private Data.Model.Model _model;

        public RwBinMeshPLG(RwVersion rwVersion, Data.Model.Model model) : base(0x50E, rwVersion)
        {
            _model = model;
        }

        protected override void WriteSectionData(BinaryWriter bw)
        {
            bw.Write(0); // Is tri-strip
            bw.Write(_model.MaterialSplits.Count);
            bw.Write(_model.GetTotalIndicesCount());

            int faceOffset = 0;
            for (int index = 0; index < _model.MaterialSplits.Count; index++)
            {
                var split = _model.MaterialSplits[index];
                bw.Write(split.Indices.Count);
                bw.Write(index);
                foreach (var faceIndex in split.Indices)
                {
                    bw.Write(faceOffset + faceIndex);
                }

                faceOffset += split.Vertices.Count;
            }
        }
    }
}