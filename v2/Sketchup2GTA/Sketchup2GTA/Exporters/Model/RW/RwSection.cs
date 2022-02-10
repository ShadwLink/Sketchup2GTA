using System.Collections.Generic;
using System.Drawing.Design;
using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public abstract class RwSection
    {
        private uint _sectionType;

        protected List<RwSection> _childSections = new List<RwSection>();
        
        public RwSection(uint sectionType)
        {
            _sectionType = sectionType;
        }

        public void Write(BinaryWriter bw)
        {
            WriteHeader(bw);
            WriteSection(bw);
            WriteChildSections(bw);
        }

        protected virtual void WriteSection(BinaryWriter bw)
        {
            // By default we do nothing
        }

        private void WriteHeader(BinaryWriter bw)
        {
            bw.Write(_sectionType);
            bw.Write(GetTotalSectionSize());
            bw.Write(0x1003FFFF); // TODO: Should be version depending on the export
        }

        private void WriteChildSections(BinaryWriter bw)
        {
            foreach (var childSection in _childSections)
            {
                childSection.Write(bw);
            }
        }

        protected virtual uint GetSectionSize()
        {
            return 0;
        }

        private uint GetTotalSectionSize()
        {
            uint sectionSize = 0;
            foreach (var childSection in _childSections)
            {
                sectionSize += childSection.GetTotalSectionSize();
            }

            return sectionSize + GetSectionSize() + 12; // 12 is Header size
        }

        protected void WriteStruct(BinaryWriter bw)
        {
            bw.Write((uint)0x01);
            bw.Write(GetSectionSize());
            bw.Write(0x1003FFFF); // TODO: Should be version depending on the export
        }
        
        public RwSection AddSection(RwSection section)
        {
            _childSections.Add(section);
            return this;
        }
    }
}