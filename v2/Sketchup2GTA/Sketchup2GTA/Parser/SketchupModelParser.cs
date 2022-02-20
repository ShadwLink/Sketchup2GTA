using System;
using System.Collections.Generic;
using System.IO;
using System.Numerics;
using Sketchup2GTA.Data.Model;
using Sketchup2GTA.Exporters.Model.RW;
using SketchUpNET;
using Material = SketchUpNET.Material;

namespace Sketchup2GTA.Parser
{
    public class SketchupModelParser
    {
        public Model Parse(string path)
        {
            var modelName = Path.GetFileNameWithoutExtension(path);

            SketchUp skp = new SketchUp();
            if (skp.LoadModel(path, true))
            {
                var meshesByMaterial = GroupMeshDataByMaterial(skp);
                
                // TODO: Move this
                List<Texture> textures = new List<Texture>();
                foreach (var item in meshesByMaterial)
                {
                    var material = item.Key;
                    if (material.UsesTexture && IsTextureValidSize(material.MaterialTexture))
                    {
                        textures.Add(material.MaterialTexture);
                    }
                }
                ExportTextures(modelName, textures);

                return CreateModel(modelName, meshesByMaterial);
            }

            return null;
        }

        private bool IsTextureValidSize(Texture texture)
        {
            var height = (float)texture.Height;
            while (height > 1)
            {
                height /= 2;
            }
            Console.WriteLine("Texture size " + texture.Height + " end " + height);

            return height == 1f;
        }

        private Dictionary<Material, List<Mesh>> GroupMeshDataByMaterial(SketchUp skp)
        {
            var meshesByMaterial = new Dictionary<Material, List<Mesh>>();
            foreach (var surface in skp.Surfaces)
            {
                if (surface.FrontMaterial.Name == "")
                {
                    Console.WriteLine("Sad days, empty materials are not supported (yet).");
                }
                else
                {
                    if (!meshesByMaterial.ContainsKey(surface.FrontMaterial))
                    {
                        meshesByMaterial.Add(surface.FrontMaterial, new List<Mesh>());
                    }

                    meshesByMaterial[surface.FrontMaterial].Add(surface.FaceMesh);
                }
            }

            return meshesByMaterial;
        }

        private Model CreateModel(string modelName, Dictionary<Material, List<Mesh>> meshesByMaterial)
        {
            Model model = new Model(modelName);
            foreach (var meshByMaterial in meshesByMaterial)
            {
                var material = meshByMaterial.Key;
                MaterialSplit split = new MaterialSplit(
                    new Data.Model.Material(
                        material.MaterialTexture.Name,
                        new MaterialColor(
                            material.Colour.R,
                            material.Colour.G,
                            material.Colour.B,
                            material.Colour.A
                        )
                    )
                );

                foreach (var mesh in meshByMaterial.Value)
                {
                    int[] vertexIndexMapping = new int[mesh.Vertices.Count];
                    for (int i = 0; i < mesh.Vertices.Count; i++)
                    {
                        var vertex = mesh.Vertices[i];
                        vertexIndexMapping[i] = split.AddVertex(new Vector3(
                                (float)vertex.X,
                                (float)vertex.Y,
                                (float)vertex.Z
                            )
                        );
                    }

                    foreach (var uv in mesh.UVs)
                    {
                        split.AddUV(new Vector2((float)uv.U, (float)uv.V));
                    }

                    foreach (var face in mesh.Faces)
                    {
                        split.AddFaceIndex(vertexIndexMapping[face.A]);
                        split.AddFaceIndex(vertexIndexMapping[face.B]);
                        split.AddFaceIndex(vertexIndexMapping[face.C]);
                    }
                }

                model.AddMaterialSplit(split);
            }

            return model;
        }

        private void ExportTextures(String txdName, List<Texture> textures)
        {
            // Bmp
            Console.WriteLine("Exporting textures " + textures.Count);
            // var bw = new BinaryWriter(new FileStream(texture.Name, FileMode.OpenOrCreate));
            // bw.Write((byte)0x42);
            // bw.Write((byte)0x4D);
            // bw.Write(texture.Data.Length + 40 + 14);
            // bw.Write(0);
            // bw.Write(54); // Data offset
            // bw.Write(40); // Header size
            // bw.Write(texture.Width);
            // bw.Write(texture.Height);
            // bw.Write((short)1); // Color planes
            // bw.Write((short)24);
            // bw.Write(0); // Compression None
            // bw.Write(texture.Data.Length);
            // bw.Write(0); // Horizontal res
            // bw.Write(0); // Vertical res
            // bw.Write(0); // Colors in palette
            // bw.Write(0); // Important colors
            // bw.Write(texture.Data);
            // bw.Flush();
            // bw.Close();

            // Txd
            var bwTxd = new BinaryWriter(new FileStream(txdName + ".txd", FileMode.OpenOrCreate));

            new RwTextureDictionary(textures)
                .PrepareForWrite()
                .Write(bwTxd);

            bwTxd.Flush();
            bwTxd.Dispose();
        }
    }
}