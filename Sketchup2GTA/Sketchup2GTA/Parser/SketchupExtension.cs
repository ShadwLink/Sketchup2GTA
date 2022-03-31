using System;
using System.Collections.Generic;
using System.Numerics;
using Sketchup2GTA.Data.Model;
using SketchUpNET;

namespace Sketchup2GTA.Parser
{
    public static class SketchupExtension
    {
        public static Bounds GetBounds(this Component component)
        {
            List<Vector3> vertices = new List<Vector3>();
            foreach (var componentEdge in component.Edges)
            {
                vertices.Add(new Vector3((float)componentEdge.Start.X, (float)componentEdge.Start.Y, (float)componentEdge.Start.Z));
                vertices.Add(new Vector3((float)componentEdge.End.X, (float)componentEdge.End.Y, (float)componentEdge.End.Z));
            }

            return new Bounds(vertices);
        }
    }
}