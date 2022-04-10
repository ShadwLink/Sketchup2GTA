using System;
using System.IO;
using Sketchup2GTA.Data.Collision;
using Sketchup2GTA.IO;

namespace Sketchup2GTA.Exporters.RW.VC
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
                bw.Write(face.C);
                bw.Write(face.B);
                bw.Write(face.A);
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
                case "":
                    return 0;
                case "street":
                    return 1;
                case "grass":
                    return 2;
                case "mud":
                    return 3;
                case "dirt":
                    return 4;
                case "concrete":
                    return 5;
                case "aluminum":
                    return 6;
                case "glass":
                    return 7;
                case "metal_pole":
                    return 8;
                case "door":
                    return 9;
                case "metal_sheet":
                    return 10;
                case "metal":
                    return 11;
                case "metal_post_small":
                    return 12;
                case "metal_post_large":
                    return 13;
                case "metal_post_medium":
                    return 14;
                case "steel":
                    return 15;
                case "fence":
                    return 16;
                case "sand":
                    return 18;
                case "water":
                    return 19;
                case "wooden_box":
                    return 20;
                case "wooden_lathes":
                    return 21;
                case "wood":
                    return 22;
                case "metal_box":
                    return 23;
                case "metal_box_2":
                    return 24;
                case "hedge":
                    return 25;
                case "rock":
                    return 26;
                case "metal_container":
                    return 27;
                case "metal_barrel":
                    return 28;
                case "metal_card_box":
                    return 30;
                case "metal_gate":
                    return 32;
                case "sand_2":
                    return 33;
                case "grass_2":
                    return 34;
                default:
                    Console.WriteLine("Unknown material: " + materialName);
                    return 0;
            }
        }
    }
}