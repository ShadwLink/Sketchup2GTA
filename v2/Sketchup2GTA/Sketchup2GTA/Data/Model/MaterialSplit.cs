using System;
using System.Collections.Generic;
using System.Numerics;

namespace Sketchup2GTA.Data.Model
{
    public class MaterialSplit
    {
        public Material Material;
        public List<Vector3> Vertices = new List<Vector3>();
        public List<Vector2> UVs = new List<Vector2>();
        public List<int> Indices = new List<int>();

        public MaterialSplit(Material material)
        {
            Material = material;
        }
        
        public int AddVertex(Vector3 vertex)
        {
            Vertices.Add(vertex);
            return Vertices.Count - 1;
        }

        public void AddUV(Vector2 uv)
        {
            UVs.Add(uv);
        }

        public void AddFaceIndex(int index)
        {
            Indices.Add(index);
        }
    }
}