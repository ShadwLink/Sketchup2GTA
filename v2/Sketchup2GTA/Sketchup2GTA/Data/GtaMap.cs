using System.Collections.Generic;

namespace Sketchup2GTA.Data
{
    public class GtaMap
    {
        public List<Group> Groups = new List<Group>();

        public void AddGroup(Group group)
        {
            Groups.Add(group);
        }
    }
}