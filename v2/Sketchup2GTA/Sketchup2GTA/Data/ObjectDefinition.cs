using System;

namespace Sketchup2GTA.Data
{
    public class ObjectDefinition
    {
        public int ID = 0;
        public String Name;
        
        public ObjectDefinition(int id, String name)
        {
            ID = id;
            Name = name;
        }
    }
}