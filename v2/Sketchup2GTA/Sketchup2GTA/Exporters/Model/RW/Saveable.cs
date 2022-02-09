using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public interface Saveable
    {
        void Save(BinaryWriter bw);
    }
}