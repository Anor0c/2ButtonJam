using Godot;
using System;

public partial class BindInput : Label
{
	[Signal]
	public delegate void OnInputBoundEventHandler();
	[Export]
	bool bindActive = true;
	[Export]
	StringName actionName = new StringName("Forward");
	[Export]
	public int bindIndex = 1;

	public void ActivateBind() => bindActive = true; 
	public void DeactivateBind() => bindActive = false; 
	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event.IsPressed()&&bindActive)
		{
			GD.Print(@event.AsText());
			Text = @event.AsText(); 
            InputMap.ActionAddEvent(actionName, @event);
			EmitSignal(SignalName.OnInputBound);  
            bindActive = false;
			
        }
	}
    private void OnLabelOnInputBound()
	{

	}
}
