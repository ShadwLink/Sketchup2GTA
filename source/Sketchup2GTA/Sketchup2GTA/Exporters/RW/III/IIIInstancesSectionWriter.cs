using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.RW.III
{
    public class IIIInstancesSectionWriter : SectionWriter
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
                    $"{instance.Position.X}, " +
                    $"{instance.Position.Y}, " +
                    $"{instance.Position.Z}, " +
                    $"1, " + // Scale X
                    $"1, " + // Scale Y
                    $"1, " + // Scale Z
                    $"{instance.Rotation.X}, " +
                    $"{instance.Rotation.Y}, " +
                    $"{instance.Rotation.Z}, " +
                    $"{instance.Rotation.W}"
                );
            }
        }
    }
}