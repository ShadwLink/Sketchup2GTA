using System;
using System.Collections.Generic;
using System.IO;
using System.Numerics;
using Sketchup2GTA.Data;
using Sketchup2GTA.Data.Model;
using Sketchup2GTA.Exporters.Model.RW;
using SketchUpNET;
using Material = SketchUpNET.Material;

namespace Sketchup2GTA.Parser
{
    public class SketchupTexturesParser
    {
        public TextureDictionary Parse(string path)
        {
            var modelName = Path.GetFileNameWithoutExtension(path);

            SketchUp skp = new SketchUp();
            if (skp.LoadModel(path, true))
            {
                return new TextureDictionary(modelName, GetAllTextures(skp));
            }

            return null;
        }

        private List<Texture> GetAllTextures(SketchUp skp)
        {
            List<Texture> textures = new List<Texture>();
            foreach (var materialByName in skp.Materials)
            {
                var material = materialByName.Value;
                if (material.UsesTexture)
                {
                    textures.Add(material.MaterialTexture);
                }
            }

            return textures;
        }
    }
}