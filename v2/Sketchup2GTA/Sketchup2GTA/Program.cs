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

            var startId = 0;
            if (args.Length == 2)
            {
                if (!int.TryParse(args[1], out startId))
                {
                    Console.WriteLine("Invalid start ID supplied");
                }
            }

            var map = new SketchupMapParser().Parse(sketchupPath, startId);
            foreach (var group in map.Groups)
            {
                new VcDefinitionExporter().Export(group);
                new VcPlacementExporter().Export(group);
            }
        }
    }
}