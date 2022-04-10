using System.Collections.Generic;
using Sketchup2GTA.Exporters;
using Sketchup2GTA.Exporters.RW;
using Sketchup2GTA.Exporters.RW.VC;

namespace Sketchup2GTA
{
    public class GameVersionVC : GameVersion
    {
        public override string GetGameName()
        {
            return "GTA: VC";
        }

        public override DefinitionExporter GetDefinitionExporter()
        {
            return new VcDefinitionExporter();
        }

        public override PlacementExporter GetPlacementExporter()
        {
            var sectionWriters = new List<SectionWriter>();
            sectionWriters.Add(new VcInstancesSectionWriter());
            sectionWriters.Add(new EmptySectionWriter("cull"));
            sectionWriters.Add(new EmptySectionWriter("pick"));
            sectionWriters.Add(new EmptySectionWriter("path"));

            return new RwPlacementExporter(sectionWriters);
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