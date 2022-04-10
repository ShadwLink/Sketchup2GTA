using System.Collections.Generic;
using Sketchup2GTA.Exporters;
using Sketchup2GTA.Exporters.RW;
using Sketchup2GTA.Exporters.RW.SA;
using Sketchup2GTA.Exporters.RW.VC;

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
            return new RwDefinitionExporter();
        }

        public override PlacementExporter GetPlacementExporter()
        {
            var sectionWriters = new List<SectionWriter>();
            sectionWriters.Add(new SaInstancesSectionWriter());
            
            return new RwPlacementExporter(sectionWriters);
        }
    }
}