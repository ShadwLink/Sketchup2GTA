using System;
using Sketchup2GTA.Exporters.VC;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.ExportModes
{
    public class DataExportMode : ExportMode
    {
        private String _sketchupPath;
        private int _startId;

        private DataExportMode(string sketchupPath, int startId)
        {
            _sketchupPath = sketchupPath;
            _startId = startId;
        }

        public void Perform()
        {
            Console.WriteLine("Opening " + _sketchupPath);

            var map = new SketchupMapParser().Parse(_sketchupPath, _startId);

            Console.WriteLine("Exporting data files");
            var definitionExporter = new VcDefinitionExporter();
            var placementExporter = new VcPlacementExporter();
            foreach (var group in map.Groups)
            {
                definitionExporter.Export(group);
                placementExporter.Export(group);
            }

            Console.WriteLine("Export finished");
        }

        public static DataExportMode CreateWithArguments(string[] args)
        {
            string sketchupPath;
            if (args.Length > 1)
            {
                sketchupPath = args[1];
            }
            else
            {
                Console.WriteLine("Missing sketchup path argument");
                return null;
            }

            var startId = 0;
            if (args.Length > 2)
            {
                int.TryParse(args[2], out startId);
            }

            return new DataExportMode(sketchupPath, startId);
        }
    }
}