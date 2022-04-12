using System;
using Sketchup2GTA.Exporters;
using Sketchup2GTA.GameVersions;

namespace Sketchup2GTA
{
    public abstract class GameVersion
    {
        public abstract string GetGameName();

        public static GameVersion FromGameArgument(string gameArgument)
        {
            switch (gameArgument)
            {
                case "iii":
                    return new GameVersionIII();
                case "vc":
                    return new GameVersionVC();
                case "sa":
                    return new GameVersionSA();
                case "iv":
                    return new GameVersionIV();
                default:
                    throw new ArgumentException($"'{gameArgument}' is not supported. Possible values: vc, sa, iv");
            }
        }

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