using System.IO;
using Sketchup2GTA.Data.Collision;
using Sketchup2GTA.IO;

namespace Sketchup2GTA.Exporters.VC
{
    public class VcCollExporter : CollisionExporter
    {
        public void Export(Collision collision, string path)
        {
            var bw = new BinaryWriter(new FileStream(path, FileMode.OpenOrCreate));

            // FourCC
            bw.WriteStringWithFixedLength("COLL", 4);
            bw.Write(CalculateFileSize(collision));
            bw.WriteStringWithFixedLength("NO_NAME", 20); // TODO: Name of the collision (fixed size 20)
            bw.WriteStringWithFixedLength("SLSU", 4); // Unknown

            bw.Write(collision.Bounds.Radius);
            bw.Write(collision.Bounds.Center);
            bw.Write(collision.Bounds.Min);
            bw.Write(collision.Bounds.Max);

            bw.Write(collision.Spheres.Count);
            foreach (var sphere in collision.Spheres)
            {
                bw.Write(sphere.Radius);
                bw.Write(sphere.Center);
                // TODO: Write material
                bw.Write(0);
            }
            
            bw.Write(0); // Line count

            bw.Write(collision.Boxes.Count);
            foreach (var box in collision.Boxes)
            {
                bw.Write(box.Min);
                bw.Write(box.Max);
                // TODO: Write material
                bw.Write(0);
            }

            // TODO: Write vertices
            bw.Write(0);
            // TODO: Write faces
            bw.Write(0);

            bw.Flush();
            bw.Close();
        }

        private int CalculateFileSize(Collision collision)
        {
            // TODO: Define constants for byte sizes
            return 64 + // Header size
                   4 + collision.Spheres.Count * 20 +
                   4 + // Line count
                   4 + collision.Boxes.Count * 28 +
                   4 + collision.Vertices.Count * 12 +
                   4 + collision.Faces.Count * 16;
        }
    }
}