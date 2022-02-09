using System.Collections.Generic;

namespace Sketchup2GTA.Data.Model
{
    public class Model
    {
        public List<MaterialSplit> MaterialSplits = new List<MaterialSplit>();

        public void AddMaterialSplit(MaterialSplit split)
        {
            MaterialSplits.Add(split);
        }
    }
}