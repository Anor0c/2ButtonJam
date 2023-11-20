using Godot;
using System;

public partial class PlayerMove : CharacterBody2D
{
	[Signal]
	public delegate void OnStaminaChangedEventHandler(float currentStamina, float maxStamina);
	[Signal]
	public delegate void OnHealthChangedEventHandler(float currentHealth, float maxHealth);
	[ExportCategory("PlayerStats")]
	[Export]
	private float Speed = 300.0f;
	[Export]
	private float JumpVelocity = -400.0f;
	[Export]
	public float MaxStamina = 100.0f;
	[Export]
	public int MaxHealth = 3; 
	[ExportGroup("StaminaCost")]
	[Export]
	private float runStaminaCost = -5.0f;
	[Export]
	private float jumpStaminaCost = -5.0f;
	[Export]
	private float fwdAttackStaminaCost = -5.0f;
	[Export]
	private float stabStaminaCost = -5.0f;
	[Export]
	private float sleepStaminaRegen = 35.0f;
	[Export]
	private float idleStaminaRegen = 5.0f;

	private AnimatedSprite2D anim;
	[ExportGroup("Hitboxes")]
	[Export]
	public CollisionShape2D jumpHitbox;
	[Export]
	public CollisionShape2D fwdAtkHitbox;
	[Export]
	public CollisionShape2D stabHitbox;

	private float currentStamina { get; set; } = 0.0f;
	private int currentHealth { get; set; } = 1;
	private int sleepCounter = 0;
    private bool isRunning = false;
	private bool isAttacking = false;
    private bool isJumping = false;
	private bool wasInAir = false;
    private bool canIdle = true;
	private bool isIdle = false;
	private bool isSleeping = false;
	private bool isHurt = false;
	private bool canMove = true;


    // Get the gravity from the project settings to be synced with RigidBody nodes.
    public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();
    public override void _Ready()
    {
        base._Ready();
		anim = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		currentStamina = MaxStamina;
		currentHealth = MaxHealth;
		IdleAnim();
    }
    public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;
		if (!canMove)
		{
			velocity = Vector2.Zero;
			Velocity = velocity;
			MoveAndSlide();
			if (isHurt)
			{
				velocity = new Vector2(-Speed / 2, -Speed / 2);
				Velocity = velocity;
				MoveAndSlide();
			}
			return;


		}


		if (!IsOnFloor())
		{
			velocity.Y += gravity * (float)delta;
			wasInAir = true;
			isRunning = false;
		}
		else  
		{
			isJumping = false;
			wasInAir = false; 
		}

		// Handle Jump.
		if (Input.IsActionJustPressed("Up") && IsOnFloor())
		{
			if (isSleeping)
				isSleeping = false;
			sleepCounter = 0;
			velocity.Y = JumpVelocity;
			JumpAnim();
			wasInAir = true;
			isJumping = true;
			isAttacking = true;
		}
		if (Input.IsActionJustPressed("Forward") && IsOnFloor())
		{
			if (isSleeping)
				isSleeping = false; 
			if (isAttacking == false)
			{
				ForwardAttackAnim();
				isAttacking = true;
			}
			else if (anim.Animation=="ForwardAttack"||anim.FrameProgress>=0.6f)
			{
				ForwardStabAnim();
				isAttacking = true;
			}

		}
		if (Input.IsActionPressed("Forward"))
		{
			if (isSleeping)
				isSleeping = false;
			velocity.X = Speed;
			sleepCounter = 0;

			if (IsOnFloor()&&isAttacking==false) 
			{
				RunAnim();
				isRunning = true;
			}
			else
			{
				isRunning = false;
			}
		}
		else
		{
			if (IsOnFloor())
			{
				velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			}
			else
			{
                velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed / 50);
            }
			isRunning = false;			
			canIdle = true;
		}
		//GD.Print(anim.Animation);

		Velocity = velocity;
		MoveAndSlide();

		if (isRunning || isJumping || !IsOnFloor() || isSleeping||isAttacking) 
		{
			//GD.Print("Run " + isRunning + " Jump " + isJumping + " On Floor " + IsOnFloor() + " Sleeping " + isSleeping);
			canIdle = false; 
		}
		else
		{
			canIdle = true;
			IdleAnim();
		}
	}
    public override void _Process(double delta)
    { 
		base._Process(delta);
		if (!canMove)
		{
			canMove=HasEnoughStamina(MaxStamina);
			return;
		}

		if (anim.Animation != "Idle")
		{
			isIdle = false;
		}
    }
    #region AnimMethods
    private void JumpAnim()
    {
		if (isJumping) { return; }
        anim.Stop();
        anim.Play("Jump");
		isJumping = true;
    }
    private void RunAnim()
    {
        if (isRunning) { return; }
        anim.Stop();
        anim.Play("Run");
    }
    private void IdleAnim()
    {
		if (!canIdle || isIdle) { return; }
        anim.Stop();
        anim.Play("Idle");
		canIdle = false;
		isIdle = true;
    }
    /*private void LandAnim()
    {
        anim.Stop();
        anim.Play("Land");
		isLanding = true; 
    }*/
	private void ForwardAttackAnim()
	{
		anim.Stop();
		anim.Play("ForwardAttack");
	}
	private void ForwardStabAnim()
	{
		anim.Stop();
		anim.Play("ForwardStab");
	}
	private void HurtAnim()
	{
		anim.Stop();
		anim.Play("Hurt");
	}
	private void DeathAnim()
	{
		canMove = false;
		anim.Stop();
		anim.Play("Death");
	}
	/*private void LayDownAnim()
	{
		anim.Stop();
		anim.Play("Death");
		anim.SpeedScale = 3.0f;
	}*/
	private void SleepAnim()
	{
		anim.Stop();
		anim.Play("Sleep");
		isSleeping = true;
	}
    #endregion
    #region AnimSignals
    //signals fired when Animations changes, loops for looping animations, or ends for non looping animations 
    private void OnAnimatedSprite2DAnimationChanged()
	{
		GD.Print(anim.Animation + " Switch");
		if (anim.Animation == "Hurt")
		{
			canMove = false;
			isHurt = true;
			isRunning = false;
            fwdAtkHitbox.Disabled = true;
            stabHitbox.Disabled = true;
            jumpHitbox.Disabled = true;
        }
		if (anim.Animation == "Jump")
		{
			StaminaUpdate(jumpStaminaCost);
            fwdAtkHitbox.Disabled = true;
            stabHitbox.Disabled = true;
			jumpHitbox.Disabled = false;
        }
		if (anim.Animation == "ForwardAttack")
		{
			StaminaUpdate(fwdAttackStaminaCost);
			fwdAtkHitbox.Disabled = false;
		}
		if (anim.Animation == "ForwardStab")
		{
			StaminaUpdate(stabStaminaCost);
			fwdAtkHitbox.Disabled = true;
			stabHitbox.Disabled = false;
		}
		if (anim.Animation == "Run"||isSleeping)
		{
			isAttacking = false;
            fwdAtkHitbox.Disabled = true;
            stabHitbox.Disabled = true;
            jumpHitbox.Disabled = true;
        }
	}
    private void OnAnimated2DSpriteAnimationLooped()
	{
		GD.Print(anim.Animation + " Restart Loop");
		if (anim.Animation == "Run")
		{
			StaminaUpdate(runStaminaCost);
		}
		if (anim.Animation == "Idle")
		{
			sleepCounter++;
			if (sleepCounter >= 3)
			{
				SleepAnim();
				sleepCounter = 0;
				return;
			}
			StaminaUpdate(idleStaminaRegen);
		}
		if (anim.Animation == "Sleep")
		{
			StaminaUpdate(sleepStaminaRegen);
		}
	}
    private void OnAnimatedSprite2DAnimationFinished()
	{
		GD.Print(anim.Animation + " Finished");
		if (anim.Animation == "ForwardAttack"||anim.Animation=="ForwardStab"||anim.Animation=="Jump")
		{
			isAttacking = false; 
		}
		if(anim.Animation == "ForwardAttack")
		{
			fwdAtkHitbox.Disabled = true;
		}
		if(anim.Animation == "ForwardStab")
		{
			stabHitbox.Disabled = true;
		}
		if(anim.Animation == "Jump")
		{
			jumpHitbox.Disabled = true; 
		}
		if (anim.Animation == "Hurt")
		{
			canMove = true;
			isHurt = false;
		}
	}
    #endregion

    #region Stamina
	private void StaminaUpdate(float delta)
	{
		currentStamina = Mathf.Clamp(currentStamina + delta, 0.0f, MaxStamina);
		EmitSignal(SignalName.OnStaminaChanged, currentStamina, MaxStamina);
		if (currentStamina == 0.0f)
		{
			StaminaDepleted();
		}
	}
	public bool HasEnoughStamina(float staminaRequired)
	{
		if (currentStamina >= staminaRequired) { return true; }
		else { return false; }
	}
	private void StaminaDepleted()
	{
		SleepAnim();
		canMove = false;
	}
    #endregion
    #region Health
	private void TakeDamage(int Damage)
	{
		currentHealth = Mathf.Clamp(currentHealth + Damage, 0, MaxHealth);
		EmitSignal(SignalName.OnHealthChanged, currentHealth, MaxHealth);
		GD.Print(currentHealth);
		if (currentHealth == 0)
		{
			DeathAnim();
		}
		else
		{
			HurtAnim();
		}
	}
    #endregion
}

