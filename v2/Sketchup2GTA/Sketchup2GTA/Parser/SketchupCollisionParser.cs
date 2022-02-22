using System;
using System.Collections.Generic;
using System.IO;
using System.Numerics;
using Sketchup2GTA.Data.Collision;
using Sketchup2GTA.Data.Model;
using SketchUpNET;
using Material = SketchUpNET.Material;

namespace Sketchup2GTA.Parser
{
    public class SketchupCollisionParser
    {
        public Collision Parse(string path)
        {
            var modelName = Path.GetFileNameWithoutExtension(path);

            SketchUp skp = new SketchUp();
            if (skp.LoadModel(path, true))
            {
                var meshesByMaterial = GroupMeshDataByMaterial(skp);
                return CreateCollision(modelName, meshesByMaterial);
            }

            return null;
        }

        private Dictionary<Material, List<Mesh>> GroupMeshDataByMaterial(SketchUp skp)
        {
            var meshesByMaterial = new Dictionary<Material, List<Mesh>>();
            foreach (var surface in skp.Surfaces)
            {
                if (!meshesByMaterial.ContainsKey(surface.FrontMaterial))
                {
                    meshesByMaterial.Add(surface.FrontMaterial, new List<Mesh>());
                }

                meshesByMaterial[surface.FrontMaterial].Add(surface.FaceMesh);
            }

            return meshesByMaterial;
        }

        private Collision CreateCollision(string name, Dictionary<Material, List<Mesh>> meshesByMaterial)
        {
            Collision coll = new Collision(name);
            foreach (var meshByMaterial in meshesByMaterial)
            {
                foreach (var mesh in meshByMaterial.Value)
                {
                    int[] vertexIndexMapping = new int[mesh.Vertices.Count];
                    for (int i = 0; i < mesh.Vertices.Count; i++)
                    {
                        var vertex = mesh.Vertices[i];
                        vertexIndexMapping[i] = coll.AddVertex(new Vector3(
                                (float)vertex.X,
                                (float)vertex.Y,
                                (float)vertex.Z
                            )
                        );
                    }

                    foreach (var face in mesh.Faces)
                    {
                        coll.AddFace(new Face(vertexIndexMapping[face.A], vertexIndexMapping[face.B], vertexIndexMapping[face.C]));
                    }
                }
            }

            return coll;
        }
    }
}