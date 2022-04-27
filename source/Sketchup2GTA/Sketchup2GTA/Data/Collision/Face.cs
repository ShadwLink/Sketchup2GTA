namespace Sketchup2GTA.Data.Collision
{
    public struct Face
    {
        public readonly int A;
        public readonly int B;
        public readonly int C;
        public readonly CollMaterial Material;

        public Face(int a, int b, int c, CollMaterial material)
        {
            A = a;
            B = b;
            C = c;
            Material = material;
        }
    }
}