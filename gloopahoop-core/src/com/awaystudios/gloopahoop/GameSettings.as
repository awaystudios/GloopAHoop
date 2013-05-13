package com.awaystudios.gloopahoop
{
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 * NOTE: these settings are overriden by an external source.
	 */
	public class GameSettings
	{
		static public var GLOOP_VERSION:String = ""; // can be changed by html via flashvars
		
		static public var STU_MODE:Boolean = false;
		static public var DEV_MODE:Boolean = false;
		static public var SHOW_PHYSICS:Boolean = false;
		static public var ROB_PATH:Boolean = false;
		static public var SHOW_GLOOP_AXIS:Boolean = false;
		
		static public var GRID_SIZE : Number = 100;
		
		static public var CANNON_BASE_X : Number = 0;
		static public var CANNON_BASE_Y : Number = 0;
		static public var CANNON_BASE_W : Number = 100;
		static public var CANNON_BASE_H : Number = 100;
		
		static public var CANNON_BARREL_X : Number = 0;
		static public var CANNON_BARREL_Y : Number = 0;
		static public var CANNON_BARREL_W : Number = 100;
		static public var CANNON_BARREL_H : Number = 100;
		
		[comment("the time to wait before enabling gloop/cannon collisions after launching, in updates")]
		static public var CANNON_PHYSICS_DELAY:Number = 16;
		
		static public var WALL_PADDING : Number = 8;
		
		
		static public var GLOOP_RADIUS : Number = 50;
		static public var GLOOP_ANGULAR_DAMPING : Number = 0;
		static public var GLOOP_FRICTION : Number = 1;
		static public var GLOOP_RESTITUTION : Number = .75;
		static public var GLOOP_LINEAR_DAMPING : Number = .1;
		
		static public var GLOOP_DECAL_SPEED_FACTOR : Number = 2;
		static public var GLOOP_DECAL_MIN_SPEED : Number = 0.5;
		static public var GLOOP_DECAL_LIMIT_PER_HIT : Number = 20;
		static public var GLOOP_DECAL_LIMIT_TOTAL : Number = 30;
		static public var GLOOP_LOST_MOMENTUM_THRESHOLD : Number = .01;
		
		[comment("delay between splats while on a surface, in updates")]
		static public var GLOOP_SPLAT_COOLDOWN : int = 20;
		
		[comment("values closer to one makes the average move faster")]
		static public var GLOOP_MOMENTUM_MULTIPLIER : Number = .1;
		
		static public var GLOOP_MAX_SPEED : Number = 5.5;
		
		static public const HOOP_RADIUS : Number = GRID_SIZE / 1.8;
		static public const HOOP_SCALE:Number = 1.5;
		
		static public var SCORE_BULLSEYE_MULTIPLIER : Number = 2;
		static public var SCORE_STAR_VALUE : Number = 350;
		static public var SCORE_BASE : Number = 500;
		
		static public var GOALWALL_DETECTOR_HEIGHT : Number = 200;
		static public var GOALWALL_DETECTOR_WIDTH : Number = 200;
		[comment("the threshold to be under to score a bullseye (0-1) lower is smaller")]
		static public var GOALWALL_BULLSEYE_THRESHOLD : Number = .2;
		
		static public var HOOP_ROTATION_STEP : Number = 45;
		
		static public var BUTTON_RADIUS : Number = 60;
		
		[comment("dragging a distance shorter than this cancels the launch")]
		static public var LAUNCHER_DRAG_MIN : Number = 70;
		[comment("the drag distance is capped to this value, dragging longer won't make a difference")]
		static public var LAUNCHER_DRAG_MAX : Number = 120;
		[comment("this is the minimal force applied when launched")]
		static public var LAUNCHER_POWER_BASE : Number = 0.7;
		[comment("a shot at 100% power will be the sum of the base and this value")]
		static public var LAUNCHER_POWER_VARIATION : Number = 1.3;
		
		static public var ROCKET_POWER : Number = 15;
		
		static public var TRAMPOLINE_RESTITUTION : Number = 1.25;
		
		static public var FAN_BODY_WIDTH : Number = 60;
		static public var FAN_BODY_HEIGHT : Number = 5;
		static public var FAN_AREA_WIDTH : Number = 60;
		static public var FAN_AREA_HEIGHT : Number = 100;
		static public var FAN_POWER : Number = 0.25;
		
		static public var FAN_ON_OFF_TIME:Number = 0.4;
		
		static public var STAR_RADIUS : Number = 30;
		
		static public var PHYSICS_SCALE : Number = 60;
		static public var PHYSICS_TIME_STEP : Number = 0.05;
		static public var PHYSICS_VELOCITY_ITERATIONS : Number = 5;
		static public var PHYSICS_POSITION_ITERATIONS : Number = 5;
		static public var PHYSICS_GRAVITY_Y : Number = 1;
		
		static public var SHOW_COLLISION_WALLS : Boolean = false;
		static public var SHOW_COSMETIC_MESHES : Boolean = true;
		
		static public var TRACE_NUM_POINTS : uint = 20;
		static public var TRACE_MIN_DTIME : Number = 1;
		static public var TRACE_MIN_DPOS_SQUARED : Number = 100;
		static public var TRACE_MIN_SCALE : Number = 0.3;
		static public var TRACE_MAX_SCALE : Number = 0.7;
		
		static public var BOX_SIZE:Number = 90;
		static public var BOX_DENSITY:Number = 0.1;
		
		[comment("the maximum time in milliseconds between down and up events to consider the input a click")]
		static public var INPUT_CLICK_TIME : uint = 250;
		[comment("the maximum distance a hoops centerpoint can be from the click to be considered hit")]
		static public var INPUT_PICK_DISTANCE : uint = 50;
		[comment("the maximum distance the cannon pin centerpoint can be from the click to be considered hit")]
		static public var INPUT_CANNON_DISTANCE : uint = 50;
		[comment("the length of cannon pin")]
		static public var INPUT_CANNON_LENGTH : uint = 70;
		[comment("the maximum distance the player needs to drag before the actual drag events happen (also disables clicking)")]
		static public var INPUT_DRAG_THRESHOLD_SQUARED : uint = 100;
		
		[comment("the number of milliseconds to wait after hitting the goal wall until dispatching the level win")]
		static public var WIN_DELAY : int = 1500;
		
		
		
		
		
		// General.
		public static const debugMode:Boolean = false; // Shows stats
		public static const useSound:Boolean = true;
		
		// Scene.
		public static const xyRange:Number = 1000;
		
		// Level progress.
		public static const killsToAdvanceDifficulty:uint = 10;
		public static const startingSpawnTimeFactor:Number = 1;
		public static const minimumSpawnTimeFactor:Number = 0.25;
		public static const spawnTimeFactorPerLevel:Number = 0.2;
		
		// Invawayders.
		public static const invawayderSizeXY:Number = 50;
		public static const invawayderSizeZ:Number = 200;
		public static const deathFragmentsIntensity:Number = 3;
		public static const particleVelocityMin:Number = 30;
		public static const particleVelocityMax:Number = 250;
		public static const particleVelocityMinZ:Number = 16;
		public static const particleVelocityMaxZ:Number = 25;
		public static const deathTimerMin:Number = 0.450;
		public static const deathTimerMax:Number = 1.250;
		public static const deathTimerFlash:Number = 125;
		public static const invawayderAnimationTimeMS:uint = 250;
		public static const impactHitSize:Number = 300;
		
		//Explosion
		public static const explosionSizeXY:Number = 50;
		public static const explosionTimerMin:Number = 0.2;
		public static const explosionTimerMax:Number = 0.6;
		
		// Player.
		public static const blasterOffsetH:Number = 100;
		public static const blasterOffsetV:Number = -100;
		public static const blasterOffsetD:Number = -1000;
		public static const blasterStrength:Number = 1;
		public static const blasterFireRateMS:Number = 50;
		public static const cameraPanRange:Number = 1750;
		public static const panTiltFactor:Number = 0;
		public static const playerHitShake:Number = 200;
		public static const playerCountShake:Number = 10;
		public static const playerLives:uint = 3;
		
		// Mouse control settings.
		public static const mouseCameraMotionEase:Number = 0.25;
		public static const mouseMotionFactor:Number = 3000;
		
		// Accelerometer control settings.
		public static const accelerometerCameraMotionEase:Number = 0.05;
		public static const accelerometerMotionFactorX:Number = 5;
		public static const accelerometerMotionFactorY:Number = 10;
		
		// Scene range.
		public static const minZ:Number = -2000;
		public static const maxZ:Number = 50000;
		
		//spawn range
		public static const minSpawnZ:Number = 15000;
		public static const maxSpawnZ:Number = 20000;
	}
	
}

