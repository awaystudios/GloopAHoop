package com.awaystudios.gloopahoop.gameobjects
{

	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.components.*;
	import com.awaystudios.gloopahoop.gameobjects.events.*;
	import com.awaystudios.gloopahoop.gameobjects.hoops.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	import away3d.materials.lightpickers.*;
	
	import Box2DAS.Common.*;
	import Box2DAS.Dynamics.*;

	public class Gloop extends DefaultGameObject
	{
		private var _splatComponent:SplatComponent;
		private var _traceComponent:PathTraceComponent;
		private var _visualComponent:GloopVisualComponent;
		
		private var _spawnX:Number;
		private var _spawnY:Number;
		
		private var _didHit : Boolean;
		
		private var _avgSpeed:Number = 0;

		public function Gloop( spawnX:Number, spawnY:Number ) {
			super();

			_spawnX = spawnX;
			_spawnY = spawnY;

			init();
		}

		private function init():void
		{
			_physics = new GloopPhysicsComponent( this );
			_physics.angularDamping = GameSettings.GLOOP_ANGULAR_DAMPING;
			_physics.friction = GameSettings.GLOOP_FRICTION;
			_physics.restitution = GameSettings.GLOOP_RESTITUTION;
			_physics.linearDamping = GameSettings.GLOOP_LINEAR_DAMPING;
			_physics.applyGravity = true;
			_physics.bullet = true;
			_physics.reportPostSolve = true;
			_physics.enableReportPreSolveContact();
//			_physics.enableReportBeginContact();
			_physics.addEventListener( ContactEvent.POST_SOLVE, contactPostSolveHandler );
			
			// Create special mesh component and use it as
			// mesh component for this default game object
			_visualComponent = new GloopVisualComponent( _physics );
			_meshComponent = _visualComponent;

			_splatComponent = new SplatComponent( _physics );
			_traceComponent = new PathTraceComponent( _physics );
		}

		override public function onCollidingWithSomethingPreSolve( event:ContactEvent ):void {

			var fixture:b2Fixture = event.other;

			if( fixture.IsSensor() ) return;

			var otherPhysics:PhysicsComponent = fixture.m_userData as PhysicsComponent;
			if( !otherPhysics ) return;

			var go:GameObject = otherPhysics.gameObject;
			var speed:Number = _physics.b2body.GetLinearVelocity().length();

			if( go is Wall || go is Box ) {
				if( speed > 1 ) {
					ouch();
					_visualComponent.setFacial( GloopVisualComponent.FACIAL_OUCH );
				}
			}
			else if( go is RocketHoop ) {
				var rocketHoop:RocketHoop = RocketHoop( go );
				if( !rocketHoop.onSideCollision ) {
					SoundManager.play( Sounds.GLOOP_CATAPULTED, SoundManager.CHANNEL_GLOOP );
				}
				else {
					ouch();
				}
			}
			else if( go is TrampolineHoop ) {
				var trampolineHoop:TrampolineHoop = TrampolineHoop( go );
				if( speed > 1 ) {
					if( !trampolineHoop.onSideCollision ) {
						SoundManager.play( Sounds.GLOOP_TRAMPOLINE_HIT, SoundManager.CHANNEL_GLOOP );
					}
					else {
						ouch();
					}
				}
			}

			super.onCollidingWithSomethingPreSolve( event );
		}

		/*override public function onCollidingWithSomethingStart( event:ContactEvent ):void {

		}*/

		private function ouch():void {
			SoundManager.playRandom( [ Sounds.GLOOP_WALL_HIT_1, Sounds.GLOOP_WALL_HIT_2, Sounds.GLOOP_WALL_HIT_3, Sounds.GLOOP_WALL_HIT_4 ], SoundManager.CHANNEL_GLOOP );
		}

		override public function setLightPicker( picker:LightPickerBase ):void {
			super.setLightPicker( picker );
			_splatComponent.setLightPicker( picker );
		}
		
		
		public function get traceComponent() : PathTraceComponent
		{
			return _traceComponent;
		}
		
		
		public function setSpawn(x : Number, y : Number) : void
		{
			_spawnX = x;
			_spawnY = y;
		}
		

		override public function reset():void {
			super.reset();
			
			_didHit = false;
			_physics.setStatic(false);

			_physics.x = _spawnX,
			_physics.y = _spawnY;
			if( _physics.b2body ) {
				_physics.syncTransform();
				_physics.b2body.SetAngularVelocity( 0 );
				_physics.b2body.SetLinearVelocity( new V2( 0, 0 ) );
			}

			_splatComponent.reset();
			_visualComponent.reset();
		}
		
		override public function update( dt:Number ):void
		{
			if (_didHit) {
				_physics.setStatic(true);
			}
			
			super.update( dt );
			
			var velocity:V2 = _physics.linearVelocity;
			var speed:Number = velocity.length();
			
			if (speed > GameSettings.GLOOP_MAX_SPEED) {
				velocity.normalize(GameSettings.GLOOP_MAX_SPEED);
				_physics.b2body.SetLinearVelocity(velocity);
			}
			
			_splatComponent.update( dt );
			_traceComponent.update( dt );
			_visualComponent.update( dt, speed, velocity.x );

			if (!inEditMode) {
				_avgSpeed -= (_avgSpeed - speed) * GameSettings.GLOOP_MOMENTUM_MULTIPLIER;
				if(_avgSpeed < GameSettings.GLOOP_LOST_MOMENTUM_THRESHOLD) {
					SoundManager.playRandom( [ Sounds.GLOOP_DIS1, Sounds.GLOOP_DIS2, Sounds.GLOOP_DIS3, Sounds.GLOOP_DIS4 ] );
					_visualComponent.setFacial( GloopVisualComponent.FACIAL_SAD );
					dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_LOST_MOMENTUM, this));
				}

				if( _avgSpeed > 5 ) {
					_visualComponent.setFacial( GloopVisualComponent.FACIAL_YIPPEE );
				}

				if( _avgSpeed < 1 ) {
					_visualComponent.setFacial( GloopVisualComponent.FACIAL_SAD );
				}
			}
		}
		
		private function contactPostSolveHandler( e:ContactEvent ):void
		{
			var force:Number = e.impulses.normalImpulse1 * .1;
			force = Math.min(force, .3);
			
			_visualComponent.bounceAndFaceDirection( -force);
			
			// kill any velocity from the contact resolution if we've hit the target
			if (_didHit) {
				_physics.b2body.SetLinearVelocity(new V2);	
			}
		}
		
		public function onApproachGoalWall() : void
		{
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_APPROACH_GOAL_WALL, this));
		}
		
		public function onMissGoalWall() : void
		{
			if (!_didHit) {
				dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_MISSED_GOAL_WALL, this));
			}
		}
		
		public function splatOnTarget(angle : Number) : void
		{
			SoundManager.play(Sounds.GAME_SPLAT);
			_visualComponent.splat(angle);
		}
		
		
		public function onLaunch():void
		{
			_visualComponent.setFacial( GloopVisualComponent.FACIAL_SMILE );

			_avgSpeed = 10;
			
			_visualComponent.bounceAndFaceDirection(.1);
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_FIRED, this));
			
			_traceComponent.reset();
		}

		public function onHitGoalWall():void {
			_didHit = true;
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_HIT_GOAL_WALL, this));
		}

		override public function get debugColor1():uint {
			return 0x84c806;
		}

		override public function get debugColor2():uint {
			return 0x7da628;
		}

		public function get splatComponent():SplatComponent {
			return _splatComponent;
		}

		public function get visualComponent():GloopVisualComponent {
			return _visualComponent;
		}
	}
}
