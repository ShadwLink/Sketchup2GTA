using System;
using System.Numerics;

namespace Sketchup2GTA.Data
{
    public class ObjectInstance
    {
        private ObjectDefinition _objectDefinition;

        public int ID
        {
            get { return _objectDefinition.ID; }
        }
        
        public String Name
        {
            get { return _objectDefinition.Name; }
        }

        public Vector3 Position;

        public ObjectInstance(ObjectDefinition objectDefinition, Vector3 position)
        {
            _objectDefinition = objectDefinition;
            Position = position;
        }
    }
}