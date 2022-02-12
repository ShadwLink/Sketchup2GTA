using System;
using Sketchup2GTA.Exporters.VC;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.ExportModes
{
    public class ModelExportMode: ExportMode
    {
        private string _sketchupPath;
        private string _exportPath;
        
        private ModelExportMode(string sketchupPath, string exportPath)
        {
            _sketchupPath = sketchupPath;
            _exportPath = exportPath;
        }
        
        public void Perform()
        {
            var model = new SketchupModelParser().Parse(_sketchupPath);
            new VcModelExporter().Export(model, _exportPath);
        }
        
        public static ModelExportMode CreateWithArguments(string[] args)
        {
            if (args.Length > 2)
            {
                return new ModelExportMode(args[1], args[2]);
            }

            Console.WriteLine("Missing sketchup path argument");
            return null;
        }
    }
}