using System.Collections.Generic;
using Sketchup2GTA.Exporters;
using Sketchup2GTA.Exporters.Model.RW;
using Sketchup2GTA.Exporters.RW;
using Sketchup2GTA.Exporters.RW.III;
using Sketchup2GTA.Exporters.RW.VC;

namespace Sketchup2GTA.GameVersions
{
    public class GameVersionIII : GameVersion
    {
        public override string GetGameName()
        {
            return "GTA: III";
        }

        public override DefinitionExporter GetDefinitionExporter()
        {
            return new RwDefinitionExporter();
        }

        public override PlacementExporter GetPlacementExporter()
        {
            var sectionWriters = new List<SectionWriter>();
            sectionWriters.Add(new IIIInstancesSectionWriter());
            
            return new RwPlacementExporter(sectionWriters);
        }
        
        public override ModelExporter GetModelExporter()
        {
            return new RwModelExporter(RwVersion.III);
        }

        public override TextureDictionaryExporter GetTextureDictionaryExporter()
        {
            return new RwTxdExporter(RwVersion.III);
        }

        public override CollisionExporter GetCollisionExporter()
        {
            return new VcCollExporter();
        }
    }
}