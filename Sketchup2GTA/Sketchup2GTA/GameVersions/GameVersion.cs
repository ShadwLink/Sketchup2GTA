using System;
using Sketchup2GTA.Exporters;

namespace Sketchup2GTA
{
    public abstract class GameVersion
    {
        public abstract string GetGameName();

        public virtual DefinitionExporter GetDefinitionExporter()
        {
            throw new NotImplementedException($"Definition exporter not available for {GetGameName()}.");
        }
        
        public virtual PlacementExporter GetPlacementExporter()
        {
            throw new NotImplementedException($"Placement exporter not available for {GetGameName()}.");
        }
        
        public virtual ModelExporter GetModelExporter()
        {
            throw new NotImplementedException($"Model exporter not available for {GetGameName()}.");
        }
        
        public virtual TextureDictionaryExporter GetTextureDictionaryExporter()
        {
            throw new NotImplementedException($"Texture Dictionary exporter not available for {GetGameName()}.");
        }
        
        public virtual CollisionExporter GetCollisionExporter()
        {
            throw new NotImplementedException($"Collision exporter not available for {GetGameName()}.");
        }
    }
}