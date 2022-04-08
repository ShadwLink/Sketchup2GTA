using System;
using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.VC
{
    public class VcDefinitionExporter : DefinitionExporter
    {
        public void Export(Group group)
        {
            StreamWriter file = new StreamWriter(group.Name + ".ide");
            file.WriteLine("# Generated using Shadow-Link SketchUp plugin");
            WriteSection(file, "objs", group, WriteObjects);
            WriteSection(file, "tobj", group, WriteEmptySection);
            WriteSection(file, "path", group, WriteEmptySection);
            WriteSection(file, "2dfx", group, WriteEmptySection);
            file.Flush();
            file.Close();
        }

        private void WriteObjects(StreamWriter file, Group group)
        {
            foreach (var definition in group.ObjectDefinitions)
            {
                file.WriteLine($"{definition.ID}, {definition.Name}, {definition.Name}, 1, 299, 0");
            }
        }

        private void WriteEmptySection(StreamWriter file, Group group)
        {
            file.WriteLine("# Unsupported");
        }

        private void WriteSection(StreamWriter file, string sectionName, Group group,
            Action<StreamWriter, Group> writeSectionAction)
        {
            file.WriteLine(sectionName);
            writeSectionAction(file, group);
            file.WriteLine("end");
        }
    }
}