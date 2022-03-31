using System;
using System.Collections.Generic;
using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.IV
{
    public class IVDefinitionExporter : DefinitionExporter
    {
        public void Export(Group group)
        {
            StreamWriter file = new StreamWriter(group.Name + ".ide");
            file.WriteLine("# Generated using Shadow-Link SketchUp plugin");
            WriteSection(file, "objs", group, WriteObjects);
            WriteSection(file, "tobj", group, WriteEmptySection);
            WriteSection(file, "tree", group, WriteEmptySection);
            WriteSection(file, "path", group, WriteEmptySection);
            WriteSection(file, "anim", group, WriteEmptySection);
            WriteSection(file, "tanm", group, WriteEmptySection);
            WriteSection(file, "mlo", group, WriteEmptySection);
            WriteSection(file, "2dfx", group, WriteEmptySection);
            WriteSection(file, "txdp", group, WriteEmptySection);
            file.Flush();
            file.Close();
        }

        private void WriteObjects(StreamWriter file, Group group)
        {
            foreach (var definition in group.ObjectDefinitions)
            {
                file.WriteLine(
                    $"{definition.Name}, {definition.Name}, 299, 0, 0, " +
                    $"{definition.Bounds.Min.X}, {definition.Bounds.Min.Y}, {definition.Bounds.Min.Z}, " +
                    $"{definition.Bounds.Max.X}, {definition.Bounds.Max.Y}, {definition.Bounds.Max.Z}, " +
                    $"{definition.Bounds.Center.X}, {definition.Bounds.Center.Y}, {definition.Bounds.Center.Z}, {definition.Bounds.Radius}");
            }
        }

        private void WriteEmptySection(StreamWriter file, Group group)
        {
            file.WriteAsync("# Unsupported");
        }

        private void WriteSection(StreamWriter file, String sectionName, Group group,
            Action<StreamWriter, Group> writeSectionAction)
        {
            file.WriteLine(sectionName);
            writeSectionAction(file, group);
            file.WriteLine("end");
        }
    }
}