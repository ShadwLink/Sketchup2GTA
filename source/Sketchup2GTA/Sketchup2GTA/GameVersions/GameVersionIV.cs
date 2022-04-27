using Sketchup2GTA.Exporters;
using Sketchup2GTA.Exporters.IV;

namespace Sketchup2GTA.GameVersions
{
    public class GameVersionIV : GameVersion
    {
        public override string GetGameName()
        {
            return "GTA: IV";
        }

        public override DefinitionExporter GetDefinitionExporter()
        {
            return new IVDefinitionExporter();
        }

        public override PlacementExporter GetPlacementExporter()
        {
            return new IVPlacementExporter(new JenkinsHasher());
        }
    }
}