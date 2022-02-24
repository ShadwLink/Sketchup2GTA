using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.VC
{
    public class VcDefinitionExporter: DefinitionExporter
    {
        public void Export(Group group)
        {
            StreamWriter file = new StreamWriter(group.Name + ".ide");
            file.WriteLine("# Generated using Shadow-Link SketchUp plugin");
            file.WriteLine("objs");
            foreach (var definition in group.Definitions)
            {
                file.WriteLine($"{definition.ID}, {definition.Name}, {definition.Name}, 1, 299, 0");
            }
            file.WriteLine("end");
            file.WriteLine("tobj");
            file.WriteLine("end");
            file.WriteLine("path");
            file.WriteLine("end");
            file.WriteLine("2dfx");
            file.WriteLine("end");
            file.Flush();
            file.Close();
        }
    }
}