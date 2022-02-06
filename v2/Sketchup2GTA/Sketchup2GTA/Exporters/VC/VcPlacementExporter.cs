using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.VC
{
    public class VcPlacementExporter: PlacementExporter
    {
        public void Export(Group group)
        {
            StreamWriter file = new StreamWriter(group.Name + ".ipl");
            file.WriteLine("# Generated using shadow-link SketchUp plugin");
            file.WriteLine("inst");
            foreach (var instance in group.Instances)
            {
                file.WriteLine($"{instance.ID}, {instance.Name}, 0, {instance.Position.X}, {instance.Position.Y}, {instance.Position.Z}, 1, 1, 1, 0, 0, 0, 1");
            }
            file.WriteLine("end");
            file.WriteLine("cull");
            file.WriteLine("end");
            file.WriteLine("pick");
            file.WriteLine("end");
            file.WriteLine("path");
            file.WriteLine("end");
            file.Flush();
            file.Dispose();
        }
    }
}