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
        
        public ModelExportMode(string sketchupPath, GameVersion gameVersion, bool exportModel, bool exportTextures, bool exportCollision)
        {
            _sketchupPath = sketchupPath;
            _gameVersion = gameVersion;
            _exportModel = exportModel;
            _exportTextures = exportTextures;
            _exportCollision = exportCollision;
        }
        
        public void Perform()
        {
            if (_exportModel)
            {
                var model = new SketchupModelParser().Parse(_sketchupPath);
                _gameVersion.GetModelExporter().Export(model, _sketchupPath.Replace(".skp", ".dff"));
            }

            if (_exportTextures)
            {
                var textureDictionary = new SketchupTexturesParser().Parse(_sketchupPath);
                _gameVersion.GetTextureDictionaryExporter().Export(textureDictionary, _sketchupPath.Replace(".skp", ".txd"));
            }

            if (_exportCollision)
            {
                _gameVersion.GetCollisionExporter().Export(new SketchupCollisionParser().Parse(_sketchupPath), _sketchupPath.Replace(".skp", ".col"));
            }
        }
    }
}