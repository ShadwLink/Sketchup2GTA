namespace Sketchup2GTA.Data.Model
{
    public class Material
    {
        public string TextureName;

        public MaterialColor MaterialColor;

        public Material(string textureName, MaterialColor materialColor)
        {
            TextureName = textureName;
            MaterialColor = materialColor;
        }
    }
}