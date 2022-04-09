using System;
using Sketchup2GTA.Exporters;
using Sketchup2GTA.Exporters.III;
using Sketchup2GTA.Exporters.SA;
using Sketchup2GTA.Exporters.VC;

namespace Sketchup2GTA
{
    public class GameVersionSA : GameVersion
    {
        public override string GetGameName()
        {
            return "GTA: SA";
        }

        public override DefinitionExporter GetDefinitionExporter()
        {
            return new VcDefinitionExporter();
        }

        public override PlacementExporter GetPlacementExporter()
        {
            return new SAPlacementExporter();
        }
    }
}