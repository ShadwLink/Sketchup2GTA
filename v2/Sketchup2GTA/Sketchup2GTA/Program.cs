using CommandLine;

namespace Sketchup2GTA
{
    class Program
    {
        static void Main(string[] args)
        {
            CommandLine.Parser.Default.ParseArguments<ExportModelOptions, ExportMapOptions>(args)
                .WithParsed<ExportModelOptions>(RunExporter)
                .WithParsed<ExportMapOptions>(RunExporter);
        }
        static void RunExporter(ExportOptions options)
        {
            options.CreateExportMode().Perform();
        }
    }
}