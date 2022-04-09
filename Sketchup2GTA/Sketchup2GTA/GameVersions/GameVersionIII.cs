using System;
using Sketchup2GTA.Exporters;
using Sketchup2GTA.Exporters.III;
using Sketchup2GTA.Exporters.VC;

namespace Sketchup2GTA
{
    public class GameVersionIII : GameVersion
    {
        public override string GetGameName()
        {
            return "GTA: III";
        }

        public override DefinitionExporter GetDefinitionExporter()
        {
            return new VcDefinitionExporter();
        }

        public override PlacementExporter GetPlacementExporter()
        {
            return new IIIPlacementExporter();
        }
    }
}