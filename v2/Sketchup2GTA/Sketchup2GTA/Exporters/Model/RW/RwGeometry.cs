using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwGeometry : RwSection
    {
        private const int HAS_POSITION = 0x2;
        private const int HAS_UV = 0x4;
        private const int HAS_VERTEX_COLORS = 0x8;
        
        private Data.Model.Model _model;

        public RwGeometry(Data.Model.Model model) : base(0x0F)
        {
            _model = model;
            AddStructSection();
        }

        private int GetFlags()
        {
            return HAS_POSITION | HAS_UV | HAS_VERTEX_COLORS;
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write(GetFlags()); // Flags
            bw.Write(_model.GetTotalFaceCount());
            bw.Write(_model.GetTotalVertexCount());
            bw.Write(1); // Always 1
            
            // TODO: Vertex color data, only set when HAS_VERTEX_COLORS is set
            //bw.Write(1); // Ambient
            //bw.Write(1); // Diffuse
            //bw.Write(1); // Specular
            // Vertex colors
            foreach (var vertex in _model.GetVertices())
            {
                bw.Write(0xFFFFFFFF);
            }

            // Write UV coords
            foreach (var uv in _model.GetUVs())
            {
                bw.Write(uv.X);
                bw.Write(uv.Y);
            }

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