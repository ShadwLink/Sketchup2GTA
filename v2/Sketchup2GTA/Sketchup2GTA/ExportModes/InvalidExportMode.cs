using System;

namespace Sketchup2GTA.ExportModes
{
    public class InvalidExportMode: ExportMode
    {
        public void Perform()
        {
            Console.WriteLine("Invalid parameters supplied");
        }
    }
}