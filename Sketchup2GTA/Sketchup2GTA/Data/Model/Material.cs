namespace Sketchup2GTA.Data.Model
{
    public class Material
    {
        public readonly string TextureName;

        public readonly MaterialColor MaterialColor;

        public Material(string textureName, MaterialColor materialColor)
        {
            TextureName = textureName;
            MaterialColor = materialColor;
        }
    }
}