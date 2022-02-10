using System;

namespace Sketchup2GTA.Exporters
{
    public interface ModelExporter
    {
        void Export(Data.Model.Model model, String path);
    }
}