namespace Sketchup2GTA.Data.Collision
{
    public struct Face
    {
        public int A;
        public int B;
        public int C;

        public Face(int a, int b, int c)
        {
            A = a;
            B = b;
            C = c;
        }
    }
}