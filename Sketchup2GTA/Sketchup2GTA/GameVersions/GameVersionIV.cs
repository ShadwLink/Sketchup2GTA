using Sketchup2GTA.Exporters.IV;

namespace Sketchup2GTA
{
    public class GameVersionIV : GameVersion
    {
        public override DefinitionExporter GetDefinitionExporter()
        {
            return new IVDefinitionExporter();
        }
    }
}