using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public abstract class RwSection: Saveable
    {
        private uint _sectionType;
        
        public RwSection(uint sectionType)
        {
            _sectionType = sectionType;
        }

        public void Save(BinaryWriter bw)
        {
            bw.Write(_sectionType);
        }
    }
}