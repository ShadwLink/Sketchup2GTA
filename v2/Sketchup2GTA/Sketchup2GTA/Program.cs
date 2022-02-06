using System;
using Sketchup2GTA.Exporters.VC;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("No sketchup file defined");
                return;
            }

            var sketchupPath = args[0];
            Console.WriteLine("Opening " + sketchupPath);
            
            var map = new SketchupMapParser().Parse(sketchupPath);
            foreach (var group in map.Groups)
            {
                new VcDefinitionExporter().Export(group);
                new VcPlacementExporter().Export(group);
            }
        }
    }
}