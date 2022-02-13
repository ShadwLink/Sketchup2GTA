using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwGeometry : RwSection
    {
        private Data.Model.Model _model;

        public RwGeometry(Data.Model.Model model) : base(0x0F)
        {
            _model = model;
            AddStructSection();
        }

        private int GetFlags()
        {
            return 0x0;
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write(GetFlags()); // Flags
            bw.Write(_model.GetTotalFaceCount());
            bw.Write(_model.GetTotalVertexCount());
            bw.Write(1); // Always 1

            // Write faces
            var indices = _model.GetIndices();
            for (int i = 0; i < indices.Count; i += 3)
            {
                bw.Write((ushort)indices[i]);
                bw.Write((ushort)indices[i + 1]);
                bw.Write((ushort)0); // TODO: Flags
                bw.Write((ushort)indices[i + 2]);
            }

            var bounds = _model.GetBounds();
            bw.Write(bounds.Center.X);
            bw.Write(bounds.Center.Y);
            bw.Write(bounds.Center.Z);
            bw.Write(bounds.Radius);

            bw.Write(1); // Unknown
            bw.Write(0); // Unknown

            // Write vertices
            var vertices = _model.GetVertices();
            foreach (var vertex in vertices)
            {
                bw.Write(vertex.X);
                bw.Write(vertex.Y);
                bw.Write(vertex.Z);
            }
        }
    }
}