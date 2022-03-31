using System;
using System.Collections.Generic;
using Sketchup2GTA.Data.Model;
using Sketchup2GTA.Parser;

namespace Sketchup2GTA.Data
{
    public class Group
    {
        public string Name { get; }
        public readonly List<ObjectDefinition> ObjectDefinitions = new List<ObjectDefinition>();
        public readonly List<ObjectInstance> Instances = new List<ObjectInstance>();

        public Group(string name)
        {
            Name = name ?? throw new ArgumentNullException(nameof(name));
        }
        
        public ObjectDefinition GetOrCreateDefinition(DefinitionIdGenerator idGenerator, String name, Bounds bounds)
        {
            var defIndex = FindIndexOfDefinition(name);
            if (defIndex != -1)
            {
                return ObjectDefinitions[defIndex];
            }
            else
            {
                var def = new ObjectDefinition(idGenerator.GetNextId(), name, bounds);
                ObjectDefinitions.Add(def);
                return def;
            }
        }

        private int FindIndexOfDefinition(String name)
        {
            for (int i = 0; i < ObjectDefinitions.Count; i++)
            {
                if (ObjectDefinitions[i].Name == name)
                {
                    return i;
                }
            }

            return -1;
        }
        
        public void AddDefinition(ObjectDefinition definition)
        {
            ObjectDefinitions.Add(definition);
        }
        
        public void AddInstance(ObjectInstance objectInstance)
        {
            Instances.Add(objectInstance);
        }
    }
}