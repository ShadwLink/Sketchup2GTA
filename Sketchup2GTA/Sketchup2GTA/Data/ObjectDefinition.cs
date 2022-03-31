using Sketchup2GTA.Data.Model;

namespace Sketchup2GTA.Data
{
    public class ObjectDefinition
    {
        public readonly int ID = 0;
        public readonly string Name;
        public readonly Bounds Bounds;
        
        public ObjectDefinition(int id, string name, Bounds bounds)
        {
            ID = id;
            Name = name;
            Bounds = bounds;
        }
    }
}