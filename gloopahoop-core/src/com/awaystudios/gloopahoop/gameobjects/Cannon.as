package com.awaystudios.gloopahoop.gameobjects
{
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.components.*;
	import com.awaystudios.gloopahoop.screens.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	import away3d.animators.*;
	import away3d.core.base.*;
	import away3d.entities.*;
	import away3d.materials.lightpickers.*;
	
	import flash.geom.*;
	import flash.utils.*;

	public class Cannon extends DefaultGameObject implements IMouseInteractive
	{
		private var _animComponent : VertexAnimationComponent;
		private var _cannonBody : Mesh;
		private var _launcher : GloopLauncherComponent;
		
		private var _frame0 : Geometry;
		private var _frame1 : Geometry;
		private var _animator : VertexAnimator;
		
		private var _timeSinceLaunch : Number = 0;
		
		private var _physicsOffset:Number = 0;
		private var _mouseX:Number;
		private var _mouseY:Number;
		
		public function get draggable():Boolean {
			return false;
		}

		public function get rotatable():Boolean {
			return false;
		}

		public function Cannon()
		{
			super();

			init();
		}
		
		
		private function init() : void
		{
			initVisual();
			initAnim();
			
			_launcher = new GloopLauncherComponent(this);
			_physics = new CannonPhysicsComponent(this);
		}
		
		
		private function initVisual() : void
		{
			_meshComponent = new MeshComponent();
			_meshComponent.mesh = AssetManager.instance.cannonMesh;
			_cannonBody = AssetManager.instance.cannonBody;
			_meshComponent.mesh.addChild(_cannonBody);
		}
		
		
		private function initAnim() : void
		{
			_frame0 = AssetManager.instance.cannonFrame0;
			_frame1 = AssetManager.instance.cannonFrame1;
			_animComponent = AssetManager.instance.cannonAnimation;
			_animator = AssetManager.instance.animator;
		}
		
		public override function setLightPicker(picker:LightPickerBase):void
		{
			super.setLightPicker(picker);
			
			_cannonBody.material.lightPicker = picker;
		}
		
		override public function reset():void {
			super.reset();
			_launcher.reset();
			
			_animComponent.play("aim");
			_animComponent.stop();
			
			// set as sensor to disable resolution of gloop collisions
			_physics.isSensor = true;
			_launcher.updateAim();
		}
		
		public function spawnGloop(gloop:Gloop, angle : Number = NaN):void {
			_launcher.catchGloop(gloop);	
			
			if (!isNaN(angle)) {
//				trace( "updating cannon orientation" );
				_physics.rotation = angle;
				updateCannonOrientation();
			}
		}
		
		
		public function onClick(mouseX:Number, mouseY:Number):void {
			// do nothing
		}
		
		public function onDragStart(mouseX:Number, mouseY:Number):void
		{
			_physicsOffset = Math.sqrt(Math.pow(mouseY - physics.y, 2) + Math.pow(mouseX - physics.x, 2)) - GameSettings.INPUT_CANNON_LENGTH;
			_mouseX = physics.x + (_physicsOffset + GameSettings.INPUT_CANNON_LENGTH)*Math.cos((-90+physics.rotation)*Math.PI/180);
			_mouseY = physics.y + (_physicsOffset + GameSettings.INPUT_CANNON_LENGTH)*Math.sin((-90+physics.rotation)*Math.PI/180);
		}
		
		public function onDragUpdate(mouseX:Number, mouseY:Number):void {
			if (_launcher.gloop) {
				
				_mouseX += (mouseX - _mouseX)*0.2;
				_mouseY += (mouseY - _mouseY)*0.2;
				
				var pow : Number;
				var dist:Point = new Point(_mouseX - physics.x, _mouseY - physics.y);
				dist.normalize(1);
				
					
				_launcher.onDragUpdate(_mouseX - dist.x*_physicsOffset, _mouseY - dist.y*_physicsOffset);
				
				pow = _launcher.shotPowerNormalized;
				_animator.update(pow*1000);
				
				updateCannonOrientation();
			}
		}
		
		public function onDragEnd(mouseX:Number, mouseY:Number):void {
			if (_launcher.gloop && _launcher.shotPowerAboveThreshold) {
				_animComponent.play('fire', 0);
				
				// TODO: Solve this in a nicer way, or at least make sure
				// it can't happen twice in parallel?
				setTimeout(function() : void {
					_launcher.onDragEnd(mouseX, mouseY);
					
					// if the launcher fired this time, reset the time since launch
					if (_launcher.fired) {
						SoundManager.play(Sounds.GAME_CANNON);
						SoundManager.playWithDelay( Sounds.GLOOP_WOOO, 0.25 * Math.random() );
						_timeSinceLaunch = 0;
					}
				}, 150);
			}
		}
		
		override public function update(dt : Number) : void
		{
			super.update(dt);
			_launcher.update(dt);
			
			_meshComponent.mesh.rotationZ = 0;
			_cannonBody.rotationZ = -90-_physics.rotation;
			
			// if the launcher has been fired and we're still a sensor
			if (_launcher.fired && _physics.isSensor) {
				
				// if enough time has passed, enable the physics
				_timeSinceLaunch += dt;
				if (_timeSinceLaunch > GameSettings.CANNON_PHYSICS_DELAY) {
					_physics.isSensor = false;
				}
			}
			
		}
		
		
		private function updateCannonOrientation() : void
		{
			var rot : Number;
			
			rot = physics.rotation;
			if (rot > 180) rot -= 360;
				
			_cannonBody.z = (rot < 0)? 0 : -300;
			_cannonBody.scaleY = (rot < 0)? 1 : -1;
			_cannonBody.scaleZ = _cannonBody.scaleY;
		}
	}
}


import Box2DAS.Common.V2;

import com.awaystudios.gloopahoop.*;
import com.awaystudios.gloopahoop.gameobjects.*;
import com.awaystudios.gloopahoop.gameobjects.components.*;

class CannonPhysicsComponent extends PhysicsComponent
{
	
	public function CannonPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		graphics.beginFill(gameObject.debugColor1);
		//graphics.drawRect( Settings.CANNON_BASE_X, Settings.CANNON_BASE_Y, Settings.CANNON_BASE_W, Settings.CANNON_BASE_H);
		
		graphics.beginFill(gameObject.debugColor2);
		graphics.drawRect( GameSettings.CANNON_BARREL_X, GameSettings.CANNON_BARREL_Y, GameSettings.CANNON_BARREL_W, GameSettings.CANNON_BARREL_H);
	}
	
	public override function shapes() : void
	{
		// used for gloop collision
		//box(Settings.CANNON_BASE_W, Settings.CANNON_BASE_H, new V2(Settings.CANNON_BASE_W / 2  + Settings.CANNON_BASE_X, Settings.CANNON_BASE_H / 2 + Settings.CANNON_BASE_Y));
		box(GameSettings.CANNON_BARREL_W, GameSettings.CANNON_BARREL_H, new V2(GameSettings.CANNON_BARREL_W / 2  + GameSettings.CANNON_BARREL_X, GameSettings.CANNON_BARREL_H / 2 + GameSettings.CANNON_BARREL_Y));
	}
	
	override public function create():void {
		super.create();

		b2fixtures[0].SetSensor(true);
		//b2fixtures[1].SetSensor(true);
		
		allowDragging = true;
		
		setStatic();
	}
}