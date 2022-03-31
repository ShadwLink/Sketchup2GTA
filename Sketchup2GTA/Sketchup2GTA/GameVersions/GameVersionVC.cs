using System;
using Sketchup2GTA.Exporters;
using Sketchup2GTA.Exporters.VC;

namespace Sketchup2GTA
{
    public class GameVersionVC : GameVersion
    {
        public override DefinitionExporter GetDefinitionExporter()
        {
            return new VcDefinitionExporter();
        }

        public override PlacementExporter GetPlacementExporter()
        {
            return new VcPlacementExporter();
        }

        public override ModelExporter GetModelExporter()
        {
            return new VcModelExporter();
        }

        public override TextureDictionaryExporter GetTextureDictionaryExporter()
        {
            return new VcTxdExporter();
        }

        public override CollisionExporter GetCollisionExporter()
        {
            return new VcCollExporter();
        }
    }
}