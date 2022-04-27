using Sketchup2GTA.Data.Collision;

namespace Sketchup2GTA.Exporters
{
    public interface CollisionExporter
    {
        void Export(Collision collision, string path);
    }
}