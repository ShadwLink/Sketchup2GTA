using System;
using System.IO;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.ExportModes
{
    public class MapExportMode : ExportMode
    {
        private readonly string _sketchupPath;
        private readonly GameVersion _gameVersion;
        private readonly string _outputPath;
        private readonly int _startId;

        public MapExportMode(string sketchupPath, GameVersion gameVersion, string outputPath, int startId)
        {
            _sketchupPath = sketchupPath;
            _gameVersion = gameVersion;
            _outputPath = outputPath;
            _startId = startId;
        }

        public void Perform()
        {
            Console.WriteLine("Opening " + _sketchupPath);

            var map = new SketchupMapParser().Parse(_sketchupPath, _startId);

            string exportPath = Path.GetDirectoryName(_sketchupPath) + "\\";
            if (_outputPath != null)
            {
                exportPath = _outputPath;
            }

            Console.WriteLine("Exporting data files to " + exportPath);
            var definitionExporter = _gameVersion.GetDefinitionExporter();
            var placementExporter = _gameVersion.GetPlacementExporter();
            foreach (var group in map.Groups)
            {
                definitionExporter.Export(group, exportPath);
                placementExporter.Export(group, exportPath);
            }

            Console.WriteLine("Export finished");
        }
    }
}