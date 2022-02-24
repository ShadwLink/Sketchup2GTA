using System;
using Sketchup2GTA.Exporters.VC;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.ExportModes
{
    public class MapExportMode : ExportMode
    {
        private readonly string _sketchupPath;
        private readonly int _startId;

        public MapExportMode(string sketchupPath, int startId)
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
    }
}