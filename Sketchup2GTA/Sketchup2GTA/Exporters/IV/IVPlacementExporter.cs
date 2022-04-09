using System;
using System.IO;
using Sketchup2GTA.Data;

namespace Sketchup2GTA.Exporters.IV
{
    public class IVPlacementExporter: PlacementExporter
    {
        private Hasher _hasher;
        
        public IVPlacementExporter(Hasher hasher)
        {
            _hasher = hasher;
        }
        
        public void Export(Group group)
        {
            var wplSteam = new FileStream(group.Name + ".wpl", FileMode.OpenOrCreate);
            BinaryWriter bw = new BinaryWriter(wplSteam);
            Console.WriteLine("Exported WPL " + wplSteam.Name);
            WriteHeader(bw, group);
            WriteInstances(bw, group);
            bw.Flush();
            bw.Close();
        }

        private void WriteHeader(BinaryWriter bw, Group group)
        {
            bw.Write(3);
            bw.Write(group.Instances.Count);
            bw.Write(0); // Unknown1
            bw.Write(0); // Garage
            bw.Write(0); // Cars
            bw.Write(0); // Cull
            bw.Write(0); // Unknown2
            bw.Write(0); // Unknown3
            bw.Write(0); // Unknown4
            bw.Write(0); // strb
            bw.Write(0); // lodc
            bw.Write(0); // zone
            bw.Write(0); // Unknown5
            bw.Write(0); // Unknown6
            bw.Write(0); // Unknown7
            bw.Write(0); // Unknown8
            bw.Write(0); // blok
        }

        private void WriteInstances(BinaryWriter bw, Group group)
        {
            foreach (var instance in group.Instances)
            {
                bw.Write(instance.Position.X);
                bw.Write(instance.Position.Y);
                bw.Write(instance.Position.Z);
                bw.Write(instance.Rotation.X);
                bw.Write(instance.Rotation.Y);
                bw.Write(instance.Rotation.Z);
                bw.Write(instance.Rotation.W);
                bw.Write(_hasher.Hash(instance.Name));
                bw.Write(0); // Unknown1
                bw.Write(-1); // TODO: Lod index
                bw.Write(0); // Unknown2
                bw.Write(0); // Unknown3
            }
        }
    }
}