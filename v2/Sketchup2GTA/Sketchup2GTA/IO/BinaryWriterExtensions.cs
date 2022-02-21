using System;
using System.IO;
using System.Numerics;

namespace Sketchup2GTA.IO
{
    public static class BinaryWriterExtensions
    {
        public static void Write(this BinaryWriter bw, Vector3 vector)
        {
            bw.Write(vector.X);
            bw.Write(vector.Y);
            bw.Write(vector.Z);
        }

        public static void Write(this BinaryWriter bw, Vector2 vector)
        {
            bw.Write(vector.X);
            bw.Write(vector.Y);
        }

        public static void WriteStringWithFixedLength(this BinaryWriter bw, string value, int length)
        {
            if (value.Length > length)
            {
                throw new ArgumentException($"Value {value} doesn't fit in fixed size {length}");
            }
            
            int bytesWritten = 0;
            for (var i = 0; i < value.Length; i++)
            {
                bw.Write(value[i]);
                bytesWritten++;
            }

            while (bytesWritten < length)
            {
                bw.Write((byte)0);
                bytesWritten++;
            }
        }

        public static void WriteString(this BinaryWriter bw, string value)
        {
            foreach (var c in value)
            {
                bw.Write(c);
            }
        }
    }
}