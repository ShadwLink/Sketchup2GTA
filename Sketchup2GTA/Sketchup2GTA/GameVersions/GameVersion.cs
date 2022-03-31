using System;
using Sketchup2GTA.Exporters;

namespace Sketchup2GTA
{
    public abstract class GameVersion
    {
        public virtual DefinitionExporter GetDefinitionExporter()
        {
            throw new NotImplementedException("Definition exporter not available for this game version.");
        }
        
        public virtual PlacementExporter GetPlacementExporter()
        {
            throw new NotImplementedException("Placement exporter not available for this game version.");
        }
        
        public virtual ModelExporter GetModelExporter()
        {
            throw new NotImplementedException("Model exporter not available for this game version.");
        }
        
        public virtual TextureDictionaryExporter GetTextureDictionaryExporter()
        {
            throw new NotImplementedException("Texture Dictionary exporter not available for this game version.");
        }
        
        public virtual CollisionExporter GetCollisionExporter()
        {
            throw new NotImplementedException("Collision exporter not available for this game version.");
        }
    }
}