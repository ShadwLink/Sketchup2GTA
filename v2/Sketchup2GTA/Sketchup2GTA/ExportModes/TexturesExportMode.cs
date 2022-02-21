using System;
using Sketchup2GTA.Exporters.VC;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.ExportModes
{
    public class TexturesExportMode: ExportMode
    {
        private string _sketchupPath;
        private string _exportPath;
        
        private TexturesExportMode(string sketchupPath, string exportPath)
        {
            _sketchupPath = sketchupPath;
            _exportPath = exportPath;
        }
        
        public void Perform()
        {
            var textureDictionary = new SketchupTexturesParser().Parse(_sketchupPath);
            new VcTxdExporter().Export(textureDictionary, _exportPath);
        }
        
        public static TexturesExportMode CreateWithArguments(string[] args)
        {
            if (args.Length > 2)
            {
                var input = args[1];
                return new TexturesExportMode(input, GetOutputPath(input, args));
            }

            Console.WriteLine("Missing sketchup path argument");
            return null;
        }

        private static string GetOutputPath(string input, string[] args)
        {
            return args.Length > 2 ? args[2] : input.Replace(".skp", ".txd");
        }
    }
}