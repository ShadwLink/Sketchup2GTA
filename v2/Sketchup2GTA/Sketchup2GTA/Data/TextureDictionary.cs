using System.Collections.Generic;
using SketchUpNET;

namespace Sketchup2GTA.Data
{
    public class TextureDictionary
    {
        public string Name;
        public List<Texture> Textures;

        public TextureDictionary(string name, List<Texture> textures)
        {
            Name = name;
            Textures = textures;
        }
    }
}