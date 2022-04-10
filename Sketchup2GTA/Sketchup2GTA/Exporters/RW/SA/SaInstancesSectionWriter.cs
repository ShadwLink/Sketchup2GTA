using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.RW.SA
{
    public class SaInstancesSectionWriter : SectionWriter
    {
        protected override string GetSectionName()
        {
            return "inst";
        }

        protected override void WriteSection(TextWriter file, Group group)
        {
            foreach (var instance in group.Instances)
            {
                file.WriteLine(
                    $"{instance.ID}, " +
                    $"{instance.Name}, " +
                    $"0, " + // Interior
                    $"{instance.Position.X}, " +
                    $"{instance.Position.Y}, " +
                    $"{instance.Position.Z}, " +
                    $"{instance.Rotation.X}, " +
                    $"{instance.Rotation.Y}, " +
                    $"{instance.Rotation.Z}, " +
                    $"{instance.Rotation.W}"
                );
            }
        }
    }
}