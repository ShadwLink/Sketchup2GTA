using System.Collections.Generic;
using System.Numerics;

namespace Sketchup2GTA.Data.Model
{
    public class Model
    {
        public string Name;
        public List<MaterialSplit> MaterialSplits = new List<MaterialSplit>();

        public Model(string name)
        {
            Name = name;
        }
        
        public void AddMaterialSplit(MaterialSplit split)
        {
            MaterialSplits.Add(split);
        }

        public uint GetTotalFaceCount()
        {
            uint faceCount = 0;
            foreach (var materialSplit in MaterialSplits)
            {
                faceCount += (uint)(materialSplit.Indices.Count / 3);
            }

            return faceCount;
        }

        public uint GetTotalIndicesCount()
        {
            uint indexCount = 0;
            foreach (var materialSplit in MaterialSplits)
            {
                indexCount += (uint)materialSplit.Indices.Count;
            }

            return indexCount;
        }

        public uint GetTotalVertexCount()
        {
            uint vertexCount = 0;
            foreach (var materialSplit in MaterialSplits)
            {
                vertexCount += (uint)materialSplit.Vertices.Count;
            }

            return vertexCount;
        }

        public List<int> GetIndices()
        {
            List<int> indices = new List<int>();
            foreach (var materialSplit in MaterialSplits)
            {
                indices.AddRange(materialSplit.Indices);
            }

            return indices;
        }
        
        public List<Vector3> GetVertices()
        {
            List<Vector3> vertices = new List<Vector3>();
            foreach (var materialSplit in MaterialSplits)
            {
                vertices.AddRange(materialSplit.Vertices);
            }

            return vertices;
        }
    }
}