using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.RW
{
    public class ObjectsSectionWriter : SectionWriter
    {
        protected override string GetSectionName()
        {
            return "objs";
        }

        protected override void WriteSection(TextWriter file, Group group)
        {
            foreach (var definition in group.ObjectDefinitions)
            {
                file.WriteLine($"{definition.ID}, {definition.Name}, {definition.Name}, 1, 299, 0");
            }
        }
    }
}