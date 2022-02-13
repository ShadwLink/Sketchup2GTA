using System;
using System.Collections.Generic;
using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public abstract class RwSection
    {
        private const int HEADER_SIZE = 12;
        
        private uint _sectionType;

        private byte[] _sectionData;

        protected List<RwSection> _childSections = new List<RwSection>();
        
        public RwSection(uint sectionType)
        {
            _sectionType = sectionType;
        }

        public RwSection PrepareForWrite()
        {
            _sectionData = CreateSectionData();
            foreach (var childSection in _childSections)
            {
                childSection.PrepareForWrite();
            }

            return this;
        }

        public void Write(BinaryWriter bw)
        {
            WriteHeader(bw);
            bw.Write(_sectionData);
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

        private uint GetSectionSize()
        {
            return (uint)_sectionData.Length;
        }

        private uint GetTotalSectionSize()
        {
            uint sectionSize = 0;
            foreach (var childSection in _childSections)
            {
                sectionSize += childSection.GetTotalSectionSize() + HEADER_SIZE;
            }

            return sectionSize + GetSectionSize();
        }

        public RwSection AddSection(RwSection section)
        {
            _childSections.Add(section);
            return this;
        }
        
        protected void AddStructSection()
        {
            AddSection(new RwStruct(CreateStructData()));
        }

        private byte[] CreateStructData()
        {
            var memoryStream = new MemoryStream();
            var bw = new BinaryWriter(memoryStream);
            WriteStructSection(bw);
            bw.Flush();
            var data = memoryStream.ToArray();
            bw.Dispose();
            return data;
        }

        private byte[] CreateSectionData()
        {
            var memoryStream = new MemoryStream();
            var bw = new BinaryWriter(memoryStream);
            WriteSection(bw);
            bw.Flush();
            var data = memoryStream.ToArray();
            bw.Dispose();
            return data;
        }

        protected virtual void WriteStructSection(BinaryWriter bw)
        {
            throw new NotImplementedException("WriteStructSection not implemented");
        }
    }
}