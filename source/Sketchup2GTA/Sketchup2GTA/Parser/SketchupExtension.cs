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

        public static Vector3 GetPosition(this Transform transform)
        {
            return new Vector3(
                (float)transform.X,
                (float)transform.Y,
                (float)transform.Z
            );
        }
        
        public static Quaternion GetRotation(this Transform transform)
        {
            var m00 = transform.Data[0];
            var m01 = transform.Data[1];
            var m02 = transform.Data[2];
            var m10 = transform.Data[4];
            var m11 = transform.Data[5];
            var m12 = transform.Data[6];
            var m20 = transform.Data[8];
            var m21 = transform.Data[9];
            var m22 = transform.Data[10];

            var tr = m00 + m11 + m22;

            double sq;
            double qw;
            double qx;
            double qy;
            double qz;
            if (tr > 0)
            {
                sq = Math.Sqrt(tr + 1.0) * 2;
                qw = 0.25 * sq;
                qx = (m21 - m12) / sq;
                qy = (m02 - m20) / sq;
                qz = (m10 - m01) / sq;
            }
            else if ((m00 > m11) & (m00 > m22))
            {
                sq = Math.Sqrt(1.0 + m00 - m11 - m22) * 2;
                qw = (m21 - m12) / sq;
                qx = 0.25 * sq;
                qy = (m01 + m10) / sq;
                qz = (m02 + m20) / sq;
            }
            else if (m11 > m22)
            {
                sq = Math.Sqrt(1.0 + m11 - m00 - m22) * 2;
                qw = (m02 - m20) / sq;
                qx = (m01 + m10) / sq;
                qy = 0.25 * sq;
                qz = (m12 + m21) / sq;
            }
            else
            {
                sq = Math.Sqrt(1.0 + m22 - m00 - m11) * 2;
                qw = (m10 - m01) / sq;
                qx = (m02 + m20) / sq;
                qy = (m12 + m21) / sq;
                qz = 0.25 * sq;
            }

            return new Quaternion((float)qx, (float)qy, (float)qz, (float)qw);
        }
    }
}