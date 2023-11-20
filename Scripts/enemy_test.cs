using Godot;
using System;

public partial class enemy_test : Node
{
	[Export]
	public int Health = 1;

	AnimatedSprite2D anim;

    public override void _Ready()
    {
        base._Ready();
		anim = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		anim.Play("Idle");
    }
    private void TakeDamage(int damage)
	{
		GD.Print("damaged for " + damage);
		Health += damage;
		if (Health == 0)
		{
			QueueFree();
		}
	}
}
