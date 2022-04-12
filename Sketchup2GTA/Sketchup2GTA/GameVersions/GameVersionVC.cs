using System.Collections.Generic;
using Sketchup2GTA.Exporters;
using Sketchup2GTA.Exporters.Model.RW;
using Sketchup2GTA.Exporters.RW;
using Sketchup2GTA.Exporters.RW.VC;

namespace Sketchup2GTA.GameVersions
{
    public class GameVersionVC : GameVersion
    {
        public override string GetGameName()
        {
            return "GTA: VC";
        }

        public override DefinitionExporter GetDefinitionExporter()
        {
            return new RwDefinitionExporter();
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
            return new RwModelExporter(RwVersion.ViceCity);
        }

        public override TextureDictionaryExporter GetTextureDictionaryExporter()
        {
            return new RwTxdExporter(RwVersion.ViceCity);
        }

        public override CollisionExporter GetCollisionExporter()
        {
            return new VcCollExporter();
        }
    }
}