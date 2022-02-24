using System.Collections.Generic;
using SketchUpNET;

namespace Sketchup2GTA.Data
{
    public class TextureDictionary
    {
        public readonly string Name;
        public readonly List<Texture> Textures;

        public TextureDictionary(string name, List<Texture> textures)
        {
            Name = name;
            Textures = textures;
        }
    }
}