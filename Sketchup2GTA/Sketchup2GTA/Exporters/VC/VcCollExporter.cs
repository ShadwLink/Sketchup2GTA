using System;
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

            bw.WriteStringWithFixedLength("COLL", 4);
            bw.Write(CalculateFileSize(collision));
            bw.WriteStringWithFixedLength(collision.Name, 20);
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
                WriteMaterial(bw, sphere.Material);
            }

            bw.Write(0); // Line count

            bw.Write(collision.Boxes.Count);
            foreach (var box in collision.Boxes)
            {
                bw.Write(box.Min);
                bw.Write(box.Max);
                WriteMaterial(bw, box.Material);
            }

            bw.Write(collision.Vertices.Count);
            foreach (var vertex in collision.Vertices)
            {
                bw.Write(vertex);
            }

            bw.Write(collision.Faces.Count);
            foreach (var face in collision.Faces)
            {
                bw.Write(face.A);
                bw.Write(face.B);
                bw.Write(face.C);
                WriteMaterial(bw, face.Material);
            }

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

        private void WriteMaterial(BinaryWriter bw, CollMaterial material)
        {
            bw.Write(MaterialByMaterialName(material.Material));
            bw.Write((byte)0);
            bw.Write((byte)0);
            bw.Write((byte)0);
        }

        private byte MaterialByMaterialName(string materialName)
        {
            // TODO: Might want to move this to some kind of config file
            switch (materialName)
            {
                case "grass":
                    return 0x2;
                case "mud":
                    return 0x3;
                case "dirt":
                    return 0x4;
                case "glass":
                    return 0x7;
                default:
                    Console.WriteLine("Unknown material: " + materialName);
                    return 0x0;
            }
        }
    }
}