using Godot;
using System;

public partial class BindRect : ColorRect
{
	BindInput bindLabel; 
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		bindLabel = GetChild<BindInput>(0);
		GD.Print(bindLabel);
	}

	public void ActivateBind()
	{
		Visible = true; 
		bindLabel.ActivateBind(); 
	}

	public void DeactivateBind() => bindLabel.DeactivateBind(); 

}
