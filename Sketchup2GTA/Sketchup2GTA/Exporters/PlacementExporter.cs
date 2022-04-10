using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters
{
    public interface PlacementExporter
    {
        void Export(Group group, string path);
    }
}