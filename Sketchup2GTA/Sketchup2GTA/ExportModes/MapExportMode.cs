using System;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.ExportModes
{
    public class MapExportMode : ExportMode
    {
        private readonly string _sketchupPath;
        private readonly GameVersion _gameVersion;
        private readonly int _startId;

        public MapExportMode(string sketchupPath, GameVersion gameVersion, int startId)
        {
            _sketchupPath = sketchupPath;
            _gameVersion = gameVersion;
            _startId = startId;
        }

        public void Perform()
        {
            Console.WriteLine("Opening " + _sketchupPath);

            var map = new SketchupMapParser().Parse(_sketchupPath, _startId);

            Console.WriteLine("Exporting data files");
            var definitionExporter = _gameVersion.GetDefinitionExporter();
            var placementExporter = _gameVersion.GetPlacementExporter();
            foreach (var group in map.Groups)
            {
                definitionExporter.Export(group);
                placementExporter.Export(group);
            }

            Console.WriteLine("Export finished");
        }
    }
}