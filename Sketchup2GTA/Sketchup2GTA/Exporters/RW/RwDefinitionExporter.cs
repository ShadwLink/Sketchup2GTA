using System.Collections.Generic;
using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.RW
{
    public class RwDefinitionExporter : DefinitionExporter
    {
        private List<SectionWriter> _sectionWriters;

        public RwDefinitionExporter()
        {
            _sectionWriters = new List<SectionWriter>();
            _sectionWriters.Add(new ObjectsSectionWriter());
            _sectionWriters.Add(new EmptySectionWriter("tobj"));
            _sectionWriters.Add(new EmptySectionWriter("path"));
            _sectionWriters.Add(new EmptySectionWriter("2dfx"));
        }

        public void Export(Group group, string path)
        {
            StreamWriter file = new StreamWriter(path + group.Name + ".ide");
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