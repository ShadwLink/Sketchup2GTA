using System;
using SketchUpNET;

namespace Sketchup2GTA.Parser
{
    public static class SketchupMaterialExtension
    {
        public static string GetTextureNameWithoutExtension(this Texture texture)
        {
            if (texture.Name == "") return "";

            return texture.Name.Substring(0, texture.Name.LastIndexOf(".", StringComparison.Ordinal));
        }
    }
}