using System.Numerics;

namespace Sketchup2GTA.Data
{
    public class ObjectInstance
    {
        private readonly ObjectDefinition _objectDefinition;

        public int ID => _objectDefinition.ID;

        public string Name => _objectDefinition.Name;

        public Vector3 Position;

        public ObjectInstance(ObjectDefinition objectDefinition, Vector3 position)
        {
            _objectDefinition = objectDefinition;
            Position = position;
        }
    }
}