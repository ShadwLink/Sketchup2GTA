using CommandLine;
using Sketchup2GTA.ExportModes;

namespace Sketchup2GTA
{
    [Verb("model", HelpText = "Export model data")]
    public class ExportModelOptions: ExportOptions
    {
        [Option(shortName: 'g', longName: "game", 
            HelpText = "Game version, currently only VC is supported")]
        public string Game { get; set; }
        
        [Option(shortName: 'i', longName: "input", Required = true,
            HelpText = "Path to Sketchup file")]
        public string Input { get; set; }

        [Option(shortName: 'm', longName: "model", Required = false, HelpText = "Export model file")]
        public bool Model { get; set; }
        
        [Option(shortName: 't', longName: "textures", Required = false, HelpText = "Export Texture Dictionary file")]
        public bool Textures { get; set; }
        
        [Option(shortName: 'c', longName: "coll", Required = false, HelpText = "Export collision file")]
        public bool Collision { get; set; }
        
        [Option(shortName: 'o', longName: "output", Required = false,
            HelpText = "Path to Export files to")]
        public string OutputPath { get; set; }
        
        public ExportMode CreateExportMode()
        {
            return new ModelExportMode(Input, GameVersion.FromGameArgument(Game), Model, Textures, Collision, OutputPath);
        }
    }
}