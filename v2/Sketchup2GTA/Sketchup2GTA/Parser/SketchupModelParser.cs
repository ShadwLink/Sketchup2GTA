using System;
using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using Sketchup2GTA.Data.Model;
using SketchUpNET;
using Material = SketchUpNET.Material;

namespace Sketchup2GTA.Parser
{
    public class SketchupModelParser
    {
        public Model Parse(string path)
        {
            SketchUp skp = new SketchUp();
            if (skp.LoadModel(path, true))
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

                Model model = new Model();

                Console.WriteLine("Material Count: " + meshesByMaterial.Count);
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

                        foreach (var face in mesh.Faces)
                        {
                            split.AddFaceIndex(vertexIndexMapping[face.A]);
                            split.AddFaceIndex(vertexIndexMapping[face.C]);
                            split.AddFaceIndex(vertexIndexMapping[face.B]);
                        }
                    }

                    model.AddMaterialSplit(split);

                    Console.WriteLine("Material " + meshByMaterial.Key.MaterialTexture.Name + " vertexCount " +
                                      split.Vertices.Count + " faceIndexCount " + split.Indices.Count);
                }

                return model;
            }

            return null;
        }
    }
}