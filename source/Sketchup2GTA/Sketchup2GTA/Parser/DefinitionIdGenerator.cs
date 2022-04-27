namespace Sketchup2GTA.Parser
{
    public class DefinitionIdGenerator
    {
        private int _id;
        
        public DefinitionIdGenerator(int startId)
        {
            _id = startId;
        }

        public int GetNextId()
        {
            return ++_id;
        }
    }
}