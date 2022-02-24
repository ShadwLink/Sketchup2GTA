using System.Collections.Generic;
using System.Numerics;
using Sketchup2GTA.Data.Model;

namespace Sketchup2GTA.Data.Collision
{
    public class Collision
    {
        public string Name;
        public readonly Bounds Bounds = new Bounds(new List<Vector3>());
        public readonly List<BoundingSphere> Spheres = new List<BoundingSphere>();
        public readonly List<BoundingBox> Boxes = new List<BoundingBox>();
        public readonly List<Vector3> Vertices = new List<Vector3>();
        public readonly List<Face> Faces = new List<Face>();

        public Collision(string name)
        {
            Name = name;
        }

        public void AddSphere(BoundingSphere sphere)
        {
            Spheres.Add(sphere);
        }

        public void AddBox(BoundingBox box)
        {
            Boxes.Add(box);
        }

        public int AddVertex(Vector3 vertex)
        {
            Bounds.UpdateBoundsWithVertex(vertex);
            
            Vertices.Add(vertex);
            return Vertices.Count - 1;
        }

        public void AddFace(Face face)
        {
            Faces.Add(face);
        }
    }
}