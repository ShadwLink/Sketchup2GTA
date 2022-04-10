using System.Collections.Generic;
using Sketchup2GTA.Exporters;
using Sketchup2GTA.Exporters.RW;
using Sketchup2GTA.Exporters.RW.III;
using Sketchup2GTA.Exporters.RW.VC;

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
            var sectionWriters = new List<SectionWriter>();
            sectionWriters.Add(new IIIInstancesSectionWriter());
            
            return new RwPlacementExporter(sectionWriters);
        }
    }
}