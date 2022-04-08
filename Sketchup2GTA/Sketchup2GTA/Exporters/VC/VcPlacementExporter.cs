using System;
using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.VC
{
    public class VcPlacementExporter : PlacementExporter
    {
        public void Export(Group group)
        {
            StreamWriter file = new StreamWriter(group.Name + ".ipl");
            file.WriteLine("# Generated using Shadow-Link SketchUp plugin");
            WriteSection(file, "inst", group, WriteInstances);
            WriteSection(file, "cull", group, WriteEmptySection);
            WriteSection(file, "pick", group, WriteEmptySection);
            WriteSection(file, "path", group, WriteEmptySection);
            file.Flush();
            file.Close();
        }

        private void WriteEmptySection(StreamWriter file, Group group)
        {
            file.WriteLine("# Unsupported");
        }

        private void WriteInstances(StreamWriter file, Group group)
        {
            foreach (var instance in group.Instances)
            {
                file.WriteLine(
                    $"{instance.ID}, {instance.Name}, 0, {instance.Position.X}, {instance.Position.Y}, {instance.Position.Z}, 1, 1, 1, 0, 0, 0, 1");
            }
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