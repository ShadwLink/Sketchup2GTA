using CommandLine;
using Sketchup2GTA.ExportModes;

namespace Sketchup2GTA
{
    [Verb("map", HelpText = "Export Sketchup scene to GTA Map files.")]
    public class ExportMapOptions: ExportOptions
    {
        [Option(shortName: 'g', longName: "game",
            Default = "vc",
            HelpText = "Game version, currently only VC is supported")]
        public string Game { get; set; }

        [Option(shortName: 'i', longName: "input", Required = true,
            HelpText = "Path to Sketchup file")]
        public string Input { get; set; }
        
        [Option(Default = 0, HelpText = "Starting ID to generate IDE files.")]
        public int ID { get; set; }

        public ExportMode CreateExportMode()
        {
            
            return new MapExportMode(Input, ID);
        }
    }
}