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
                Max = vertices[1];
                
                foreach (var vertex in vertices)
                {
                    Min.X = Math.Min(vertex.X, Min.X);
                    Min.Y = Math.Min(vertex.Y, Min.Y);
                    Min.Z = Math.Min(vertex.Z, Min.Z);
                    Max.X = Math.Max(vertex.X, Max.X);
                    Max.Y = Math.Max(vertex.Y, Max.Y);
                    Max.Z = Math.Max(vertex.Z, Max.Z);
                }

                Center = (Min + Max) / 2;
                Radius = Math.Max(Max.X - Center.X, Radius);
                Radius = Math.Max(Max.Y - Center.Y, Radius);
                Radius = Math.Max(Max.Z - Center.Z, Radius);
            }
            else
            {
                Min = Vector3.Zero;
                Max = Vector3.Zero;
                Center = Vector3.Zero;
                Radius = 0f;
            }
        }
    }
}