using System;
using System.Collections.Generic;
using System.IO;

namespace Sketchup2GTA.Exporters.Model.RW
{
    public abstract class RwSection
    {
        private const int HEADER_SIZE = 12;
        
        private uint _sectionType;
        protected RwVersion RwVersion;

        private byte[] _sectionData;

        protected List<RwSection> _childSections = new List<RwSection>();
        
        public RwSection(uint sectionType, RwVersion rwVersion)
        {
            _sectionType = sectionType;
            RwVersion = rwVersion;
        }

        private void PrepareForWrite()
        {
            _sectionData = CreateSectionData();
            foreach (var childSection in _childSections)
            {
                childSection.PrepareForWrite();
            }
        }

        public void Write(BinaryWriter bw)
        {
            PrepareForWrite();
            WriteSection(bw);
        }

        private void WriteSection(BinaryWriter bw)
        {
            WriteHeader(bw);
            bw.Write(_sectionData);
            WriteChildSections(bw);
        }

        protected virtual void WriteSectionData(BinaryWriter bw)
        {
            // By default we do nothing
        }

        private void WriteHeader(BinaryWriter bw)
        {
            bw.Write(_sectionType);
            bw.Write(GetTotalSectionSize());
            bw.Write((int)RwVersion);
        }

        private void WriteChildSections(BinaryWriter bw)
        {
            foreach (var childSection in _childSections)
            {
                childSection.WriteSection(bw);
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
            AddSection(new RwStruct(CreateStructData(), RwVersion));
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
            WriteSectionData(bw);
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