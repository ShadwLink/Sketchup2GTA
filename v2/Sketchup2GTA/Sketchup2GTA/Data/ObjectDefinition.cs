namespace Sketchup2GTA.Data
{
    public class ObjectDefinition
    {
        public readonly int ID = 0;
        public readonly string Name;
        
        public ObjectDefinition(int id, string name)
        {
            ID = id;
            Name = name;
        }
    }
}