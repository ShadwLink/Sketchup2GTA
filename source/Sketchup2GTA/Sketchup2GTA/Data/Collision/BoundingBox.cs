using System.Numerics;

namespace Sketchup2GTA.Data.Collision
{
    public struct BoundingBox
    {
        public Vector3 Min;
        public Vector3 Max;
        public CollMaterial Material;
    }
}