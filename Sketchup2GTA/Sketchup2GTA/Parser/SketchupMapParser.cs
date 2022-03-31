using System;
using System.Numerics;
using Sketchup2GTA.Data;
using SketchUpNET;
using Component = SketchUpNET.Component;
using Group = Sketchup2GTA.Data.Group;

namespace Sketchup2GTA.Parser
{
    public class SketchupMapParser
    {
        public GtaMap Parse(String path, int startId)
        {
            DefinitionIdGenerator idGenerator = new DefinitionIdGenerator(startId);

            SketchUp skp = new SketchUp();
            if (skp.LoadModel(path, false))
            {
                GtaMap map = new GtaMap();
                foreach (var placementInstance in skp.Instances)
                {
                    if (placementInstance.Parent is Component component && component.Instances.Count > 0)
                    {
                        Console.WriteLine("Parsing " + GetName(placementInstance) + " instances: " +
                                          component.Instances.Count);
                        Group group = new Group(GetName(placementInstance));
                        foreach (var instance in component.Instances)
                        {
                            var componentBounds = ((Component)instance.Parent).GetBounds();

                            var definition = group.GetOrCreateDefinition(idGenerator, GetName(instance), componentBounds);
                            var gtaInstance = new ObjectInstance(
                                definition,
                                new Vector3(
                                    (float)instance.Transformation.X,
                                    (float)instance.Transformation.Y,
                                    (float)instance.Transformation.Z
                                )
                            );
                            group.AddInstance(gtaInstance);
                        }

                        map.AddGroup(group);
                    }
                }

                return map;
            }

            Console.WriteLine("Unable to load model");
            return null;
        }

        private String GetName(Instance instance)
        {
            String name = "";
            if (instance.Name == "")
            {
                if (instance.Parent is Component component)
                {
                    name = component.Name;
                }
            }
            else
            {
                name = instance.Name;
            }

            if (name.Contains("#"))
            {
                name = name.Substring(0, name.IndexOf("#", StringComparison.OrdinalIgnoreCase));
            }

            return name;
        }
    }
}