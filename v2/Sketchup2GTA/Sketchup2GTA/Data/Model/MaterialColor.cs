namespace Sketchup2GTA.Data.Model
{
    public class MaterialColor
    {
        public byte r;
        public byte g;
        public byte b;
        public byte a;

        public MaterialColor(byte r, byte g, byte b, byte a)
        {
            this.r = r;
            this.g = g;
            this.b = b;
            this.a = a;
        }
    }
}