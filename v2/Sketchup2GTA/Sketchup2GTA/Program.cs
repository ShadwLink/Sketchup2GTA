using System;
using Sketchup2GTA.Exporters.VC;
using Sketchup2GTA.ExportModes;
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

            var mode = ParseArgs(args);
            mode?.Perform();
        }

        private static ExportMode ParseArgs(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("Invalid arguments supplied");
                return new InvalidExportMode();
            }

            switch (args[0])
            {
                case "--data":
                    return DataExportMode.CreateWithArguments(args);
                case "--model":
                    return ModelExportMode.CreateWithArguments(args);
                case "--textures":
                    return TexturesExportMode.CreateWithArguments(args);
                default:
                    return new InvalidExportMode();
            }
        }
    }
}