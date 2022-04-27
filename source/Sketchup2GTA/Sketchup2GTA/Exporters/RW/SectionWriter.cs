using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.RW
{
    public abstract class SectionWriter
    {
        public void Write(TextWriter file, Group group)
        {
            file.WriteLine(GetSectionName());
            WriteSection(file, group);
            file.WriteLine("end");
        }

        protected abstract string GetSectionName();

        protected abstract void WriteSection(TextWriter file, Group group);
    }
}