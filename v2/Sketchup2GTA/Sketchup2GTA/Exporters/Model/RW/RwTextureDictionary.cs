using System.Collections.Generic;
using System.IO;
using SketchUpNET;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public class RwTextureDictionary : RwSection
    {
        private List<Texture> _textures;

        public RwTextureDictionary(List<Texture> textures) : base(0x16)
        {
            _textures = textures;
            AddStructSection();

            foreach (var texture in textures)
            {
                AddSection(new RwTextureNative(texture)
                    .AddSection(new RwExtension()));
            }

            AddSection(new RwExtension());
        }

        protected override void WriteStructSection(BinaryWriter bw)
        {
            bw.Write(_textures.Count); // Texture count
        }
    }
}