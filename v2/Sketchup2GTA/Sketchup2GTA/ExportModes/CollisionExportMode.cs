using System;
using Sketchup2GTA.Data.Collision;
using Sketchup2GTA.Exporters.VC;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.ExportModes
{
    public class CollisionExportMode: ExportMode
    {
        private string _sketchupPath;
        private string _exportPath;
        
        private CollisionExportMode(string sketchupPath, string exportPath)
        {
            _sketchupPath = sketchupPath;
            _exportPath = exportPath;
        }
        
        public void Perform()
        {
            new VcCollExporter().Export(new Collision(), _exportPath);
        }
        
        public static CollisionExportMode CreateWithArguments(string[] args)
        {
            if (args.Length > 2)
            {
                var input = args[1];
                return new CollisionExportMode(input, GetOutputPath(input, args));
            }

            Console.WriteLine("Missing sketchup path argument");
            return null;
        }

        private static string GetOutputPath(string input, string[] args)
        {
            return args.Length > 2 ? args[2] : input.Replace(".skp", ".col");
        }
    }
}