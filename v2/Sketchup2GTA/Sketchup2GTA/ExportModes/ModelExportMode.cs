using System;
using Sketchup2GTA.Exporters.VC;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.ExportModes
{
    public class ModelExportMode: ExportMode
    {
        private string _sketchupPath;
        private bool _exportModel;
        private bool _exportTextures;
        private bool _exportCollision;
        
        public ModelExportMode(string sketchupPath, bool exportModel,  bool exportTextures, bool exportCollision)
        {
            _sketchupPath = sketchupPath;
            _exportModel = exportModel;
            _exportTextures = exportTextures;
            _exportCollision = exportCollision;
        }
        
        public void Perform()
        {
            if (_exportModel)
            {
                var model = new SketchupModelParser().Parse(_sketchupPath);
                new VcModelExporter().Export(model, _sketchupPath.Replace(".skp", ".dff"));
            }

            if (_exportTextures)
            {
                var textureDictionary = new SketchupTexturesParser().Parse(_sketchupPath);
                new VcTxdExporter().Export(textureDictionary, _sketchupPath.Replace(".skp", ".txd"));
            }

            if (_exportCollision)
            {
                new VcCollExporter().Export(new SketchupCollisionParser().Parse(_sketchupPath), _sketchupPath.Replace(".skp", ".col"));
            }
        }
    }
}