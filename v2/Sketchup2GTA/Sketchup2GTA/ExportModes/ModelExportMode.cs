using System;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.ExportModes
{
    public class ModelExportMode: ExportMode
    {
        private string _sketchupPath;
        
        private ModelExportMode(string sketchupPath)
        {
            _sketchupPath = sketchupPath;
        }
        
        public void Perform()
        {
            new SketchupModelParser().Parse(_sketchupPath);
        }
        
        public static ModelExportMode CreateWithArguments(string[] args)
        {
            if (args.Length > 1)
            {
                return new ModelExportMode(args[1]);
            }

            Console.WriteLine("Missing sketchup path argument");
            return null;
        }
    }
}