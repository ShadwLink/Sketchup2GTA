using System;
using System.Collections.Generic;
using System.Numerics;

namespace Sketchup2GTA.Data.Model
{
    public class Bounds
    {
        // Box
        public Vector3 Min;
        public Vector3 Max;
        
        // Sphere
        public Vector3 Center;
        public float Radius;
        
        public Bounds(List<Vector3> vertices)
        {
            if (vertices.Count > 0)
            {
                Min = vertices[0];
                Max = vertices[0];
                
                foreach (var vertex in vertices)
                {
                    Min.X = Math.Min(vertex.X, Min.X);
                    Min.Y = Math.Min(vertex.Y, Min.Y);
                    Min.Z = Math.Min(vertex.Z, Min.Z);
                    Max.X = Math.Max(vertex.X, Max.X);
                    Max.Y = Math.Max(vertex.Y, Max.Y);
                    Max.Z = Math.Max(vertex.Z, Max.Z);
                }

                UpdateBoundingSphere();
            }
            else
            {
                Min = Vector3.Zero;
                Max = Vector3.Zero;
                Center = Vector3.Zero;
                Radius = 0f;
            }
        }

        public void UpdateBoundsWithVertex(Vector3 vertex)
        {
            Min.X = Math.Min(vertex.X, Min.X);
            Min.Y = Math.Min(vertex.Y, Min.Y);
            Min.Z = Math.Min(vertex.Z, Min.Z);
            Max.X = Math.Max(vertex.X, Max.X);
            Max.Y = Math.Max(vertex.Y, Max.Y);
            Max.Z = Math.Max(vertex.Z, Max.Z);
            UpdateBoundingSphere();
        }

        private void UpdateBoundingSphere()
        {
            Center = (Min + Max) / 2;
            Radius = Math.Abs((Max - Center).Length());
        }
    }
}