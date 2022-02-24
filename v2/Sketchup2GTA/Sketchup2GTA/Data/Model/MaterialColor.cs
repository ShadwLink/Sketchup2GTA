namespace Sketchup2GTA.Data.Model
{
    public class MaterialColor
    {
        public readonly byte r;
        public readonly byte g;
        public readonly byte b;
        public readonly byte a;

        public MaterialColor(byte r, byte g, byte b, byte a)
        {
            this.r = r;
            this.g = g;
            this.b = b;
            this.a = a;
        }
    }
}