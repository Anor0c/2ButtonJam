using Godot;
using Microsoft.Win32.SafeHandles;
using System;
using System.ComponentModel.Design;
using System.Linq;

public partial class UIVisibility : Control
{
	[Export]
    int bindIndex = 0;
	Godot.Collections.Array<ColorRect> bindButtonArray;   
	/*logique pour rebind les touche, a refaire plus tard
	 * public override void _Ready()
	{
		foreach (Node child in GetChildren())
		{
			if (!child.IsClass("ColorRect")) { return; }

			bindButtonArray.Add(child as ColorRect);
			GD.Print(bindButtonArray.Count() + "Buttons in scene");
		}
	}

    private void OnLabelOnInputBound()
	{
		bindIndex++;
		GD.Print(bindIndex);

		if (bindIndex >= 2)
		{
			//logique pour passer de cet ecran au main menu
		}
	}*/
}
