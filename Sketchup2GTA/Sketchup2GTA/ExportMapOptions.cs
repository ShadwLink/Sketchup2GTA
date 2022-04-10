using System;
using CommandLine;
using Sketchup2GTA.ExportModes;

namespace Sketchup2GTA
{
    [Verb("map", HelpText = "Export Sketchup scene to GTA Map files.")]
    public class ExportMapOptions: ExportOptions
    {
        [Option(shortName: 'g', longName: "game", Required = true,
            HelpText = "Game version. Possible values: iii, vc, iv")]
        public string Game { get; set; }

        [Option(shortName: 'i', longName: "input", Required = true,
            HelpText = "Path to Sketchup file")]
        public string Input { get; set; }
        
        [Option(Default = 0, HelpText = "Starting ID to generate IDE files.")]
        public int ID { get; set; }
        
        [Option(shortName: 'o', longName: "output", Required = false,
            HelpText = "Path to Export files to")]
        public string OutputPath { get; set; }

        public ExportMode CreateExportMode()
        {
            return new MapExportMode(Input, GetGameVersion(Game), OutputPath, ID);
        }

        private GameVersion GetGameVersion(string game)
        {
            switch (game)
            {
                case "iii":
                    return new GameVersionIII();
                case "vc":
                    return new GameVersionVC();
                case "sa":
                    return new GameVersionSA();
                case "iv":
                    return new GameVersionIV();
                default:
                    throw new ArgumentException($"'{game}' is not supported. Possible values: vc, iv");
            }
        }
    }
}