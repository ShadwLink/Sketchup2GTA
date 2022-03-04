using System;
using System.Collections.Generic;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.Data
{
    public class Group
    {
        public string Name { get; }
        public readonly List<ObjectDefinition> Definitions = new List<ObjectDefinition>();
        public readonly List<ObjectInstance> Instances = new List<ObjectInstance>();

        public Group(string name)
        {
            Name = name ?? throw new ArgumentNullException(nameof(name));
        }
        
        public ObjectDefinition GetOrCreateDefinition(DefinitionIdGenerator idGenerator, String name)
        {
            var defIndex = FindIndexOfDefinition(name);
            if (defIndex != -1)
            {
                return Definitions[defIndex];
            }
            else
            {
                var def = new ObjectDefinition(idGenerator.GetNextId(), name);
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