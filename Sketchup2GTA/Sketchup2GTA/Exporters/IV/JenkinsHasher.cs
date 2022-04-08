using System.Globalization;

namespace Sketchup2GTA.Exporters.IV
{
    public class JenkinsHasher: Hasher
    {
        public int Hash(string input)
        {
            input = input.ToLower(CultureInfo.InvariantCulture);
            
            int i = 0;
            int hash = 0;
            while (i != input.Length) {
                hash += input[i++];
                hash += hash << 10;
                hash ^= hash >> 6;
            }
            hash += hash << 3;
            hash ^= hash >> 11;
            hash += hash << 15;
            return hash;
        }
    }
}