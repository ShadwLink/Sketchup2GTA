using System.Numerics;

namespace Sketchup2GTA.Data
{
    public class ObjectInstance
    {
        private readonly ObjectDefinition _objectDefinition;

        public int ID => _objectDefinition.ID;

        public string Name => _objectDefinition.Name;

        public readonly Vector3 Position;
        public readonly Quaternion Rotation;

        public ObjectInstance(ObjectDefinition objectDefinition, Vector3 position, Quaternion rotation)
        {
            _objectDefinition = objectDefinition;
            Position = position;
            Rotation = rotation;
        }
    }
}