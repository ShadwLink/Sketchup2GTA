using System;
using System.Collections.Generic;

namespace Sketchup2GTA.Data
{
    public class Group
    {
        public String Name { get; private set; }
        public List<ObjectDefinition> Definitions = new List<ObjectDefinition>();
        public List<ObjectInstance> Instances = new List<ObjectInstance>();

        public Group(String name)
        {
            Name = name;
        }
        
        public ObjectDefinition GetOrCreateDefinition(String name)
        {
            var defIndex = FindIndexOfDefinition(name);
            if (defIndex != -1)
            {
                return Definitions[defIndex];
            }
            else
            {
                var def = new ObjectDefinition(name);
                Definitions.Add(def);
                return def;
            }
        }

        private int FindIndexOfDefinition(String name)
        {
            for (int i = 0; i < Definitions.Count; i++)
            {
                if (Definitions[i].Name == name)
                {
                    return i;
                }
            }

            return -1;
        }
        
        public void AddDefinition(ObjectDefinition definition)
        {
            Definitions.Add(definition);
        }
        
        public void AddInstance(ObjectInstance objectInstance)
        {
            Instances.Add(objectInstance);
        }
    }
}