using System.Collections.Generic;
using Sketchup2GTA.Exporters;
using Sketchup2GTA.Exporters.Model.RW;
using Sketchup2GTA.Exporters.RW;
using Sketchup2GTA.Exporters.RW.SA;
using Sketchup2GTA.Exporters.RW.VC;

namespace Sketchup2GTA.GameVersions
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

        public override ModelExporter GetModelExporter()
        {
            return new RwModelExporter(RwVersion.SanAndreas);
        }

        public override TextureDictionaryExporter GetTextureDictionaryExporter()
        {
            return new RwTxdExporter(RwVersion.SanAndreas);
        }
        
        public override CollisionExporter GetCollisionExporter()
        {
            return new VcCollExporter();
        }
    }
}