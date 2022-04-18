using System;
using System.IO;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.ExportModes
{
    public class ModelExportMode: ExportMode
    {
        private readonly string _sketchupPath;
        private readonly GameVersion _gameVersion;
        private readonly bool _exportModel;
        private readonly bool _exportTextures;
        private readonly bool _exportCollision;
        private readonly string _outputPath;
        
        public ModelExportMode(string sketchupPath, GameVersion gameVersion, bool exportModel, bool exportTextures, bool exportCollision, string outputPath)
        {
            _sketchupPath = sketchupPath;
            _gameVersion = gameVersion;
            _exportModel = exportModel;
            _exportTextures = exportTextures;
            _exportCollision = exportCollision;
            _outputPath = outputPath;
        }
        
        public void Perform()
        {
            var fileName = Path.GetFileNameWithoutExtension(_sketchupPath);
            string exportPath = Path.GetDirectoryName(_sketchupPath) + "\\";
            if (_outputPath != null)
            {
                exportPath = _outputPath;
            }
            
            if (_exportModel)
            {
                var modelPath = $"{exportPath}/{fileName}.dff";
                Console.WriteLine($"Exporting model to {modelPath}");
                
                var model = new SketchupModelParser().Parse(_sketchupPath);
                _gameVersion.GetModelExporter().Export(model, modelPath);
            }

            if (_exportTextures)
            {
                var textureDicPath = $"{exportPath}/{fileName}.txd";
                Console.WriteLine($"Exporting texture dictionary to {textureDicPath}");
                
                var textureDictionary = new SketchupTexturesParser().Parse(_sketchupPath);
                _gameVersion.GetTextureDictionaryExporter().Export(textureDictionary, textureDicPath);
            }

            if (_exportCollision)
            {
                var collPath = $"{exportPath}/{fileName}.col";
                Console.WriteLine($"Exporting coll to {collPath}");
                
                var coll = new SketchupCollisionParser().Parse(_sketchupPath);
                _gameVersion.GetCollisionExporter().Export(coll, collPath);
            }
        }
    }
}