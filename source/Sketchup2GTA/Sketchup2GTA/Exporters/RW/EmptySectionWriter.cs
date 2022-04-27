using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.RW
{
    public class EmptySectionWriter : SectionWriter
    {
        private string _sectionName;

        public EmptySectionWriter(string sectionName)
        {
            _sectionName = sectionName;
        }
        
        protected override string GetSectionName()
        {
            return _sectionName;
        }

        protected override void WriteSection(TextWriter file, Group group)
        {
            file.WriteLine("# Unsupported");
        }
    }
}