using System.Collections.Generic;
using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.RW
{
    public class RwPlacementExporter: PlacementExporter
    {
        private List<SectionWriter> _sectionWriters;

        public RwPlacementExporter(List<SectionWriter> sectionWriters)
        {
            _sectionWriters = sectionWriters;
        }
        
        public void Export(Group group)
        {
            StreamWriter file = new StreamWriter(group.Name + ".ipl");
            file.WriteLine("# Generated using Shadow-Link SketchUp plugin");
            foreach (var sectionWriter in _sectionWriters)
            {
                sectionWriter.Write(file, group);
            }
            file.Flush();
            file.Close();
        }
    }
}