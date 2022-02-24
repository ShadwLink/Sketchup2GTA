using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters
{
    public interface TextureDictionaryExporter
    {
        void Export(TextureDictionary dictionary, string path);
    }
}