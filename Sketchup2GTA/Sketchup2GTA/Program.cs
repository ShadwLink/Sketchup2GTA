﻿using System;
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
            Console.WriteLine("Export completed");
            Console.ReadLine();
        }
        static void RunExporter(ExportOptions options)
        {
            options.CreateExportMode().Perform();
        }
    }
}