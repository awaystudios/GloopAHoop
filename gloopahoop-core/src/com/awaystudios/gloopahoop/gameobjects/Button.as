package com.awaystudios.gloopahoop.gameobjects
{

	import Box2DAS.Dynamics.*;
	
	import away3d.core.base.*;
	import away3d.entities.*;
	import away3d.library.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.components.*;
	import com.awaystudios.gloopahoop.sounds.*;
	import com.greensock.*;
	
	public class Button extends DefaultGameObject
	{
		private var _pressed : Boolean;
		private var _btnGroup : uint;
		private var _buttonMesh : Mesh;
		
		private var _controllables : Vector.<IButtonControllable>;

		override public function dispose():void {
//			_buttonMesh = null;
		}
		
		public function Button(worldX:Number = 0, worldY:Number = 0, rotation:Number = 0, btnGroup : uint = 0)
		{
			_physics = new ButtonPhysicsComponent(this);
			_physics.x = worldX + GameSettings.WALL_PADDING*Math.sin(rotation*Math.PI/180);
			_physics.y = worldY - GameSettings.WALL_PADDING*Math.cos(rotation*Math.PI/180);
			_physics.rotation = rotation;
			_physics.fixedRotation = true;
			_physics.applyGravity = false;
			_physics.enableReportBeginContact();
			_physics.setStatic();
			
			_btnGroup = btnGroup;
			
			_controllables = new Vector.<IButtonControllable>();

			initVisual();
		}
		
		
		private function initVisual() : void
		{
			var buttonMat : ColorMaterial;
			var plateMat : ColorMaterial;
			
			plateMat = new ColorMaterial(0xaf68c2);
			
			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(Geometry(AssetLibrary.getAsset('ButtonPlate_geom')), plateMat);
			
			buttonMat = new ColorMaterial(0x4c0c5d);
			
			_buttonMesh = new Mesh(Geometry(AssetLibrary.getAsset('Button_geom')), buttonMat);
			_meshComponent.mesh.addChild(_buttonMesh);
		}
		
		
		public override function setLightPicker(picker:LightPickerBase):void
		{
			super.setLightPicker(picker);
			_buttonMesh.material.lightPicker = picker;
		}
		
		override public function reset():void 
		{
			super.reset();
			toggleOff();
		}
		
		
		public function get buttonGroup() : uint
		{
			return _btnGroup;
		}
		
		
		public function addControllable(controllable : IButtonControllable) : void
		{
			_controllables.push(controllable);
		}
		
		
		public override function onCollidingWithGloopStart( gloop : Gloop, event:ContactEvent = null ) : void
		{
			_pressed = !_pressed;
			
			SoundManager.play(Sounds.GAME_BUTTON);
			SoundManager.playWithDelay( Sounds.GLOOP_BUTTON_HIT, 0.25 * Math.random() );
			
			if (_pressed) toggleOn(true);
			else toggleOff(true);
		}
		
		
		private function toggleOn(animate : Boolean = false) : void
		{
			var i : uint;
			
			if (animate) {
				TweenLite.to(_buttonMesh, 0.5, { y: -10 });
			}
			else {
				_buttonMesh.y = -10;
			}
			
			_pressed = true;
			
			for (i=0; i<_controllables.length; i++) {
				_controllables[i].toggleOn();
			}
		}
		
		
		private function toggleOff(animate : Boolean = false) : void
		{
			var i : uint;
			
			if (animate) {
				TweenLite.to(_buttonMesh, 0.5, { y: 0 });
			}
			else {
				_buttonMesh.y = 0;
			}
			
		
			_pressed = false;
			
			for (i=0; i<_controllables.length; i++) {
				_controllables[i].toggleOff();
			}
		}
		
		override public function get debugColor1():uint {
			return 0xde6a14;
		}
	}
}

import com.awaystudios.gloopahoop.*;
import com.awaystudios.gloopahoop.gameobjects.*;
import com.awaystudios.gloopahoop.gameobjects.components.*;

class ButtonPhysicsComponent extends PhysicsComponent
{
	
	public function ButtonPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		
		graphics.beginFill(gameObject.debugColor1);
		graphics.drawRect( -GameSettings.BUTTON_RADIUS, -GameSettings.BUTTON_RADIUS / 6, GameSettings.BUTTON_RADIUS * 2, GameSettings.BUTTON_RADIUS / 3);
		
		//graphics.beginFill(0x0);
		//graphics.moveTo( 0, -Settings.BUTTON_RADIUS / 6);
		//graphics.lineTo( -Settings.BUTTON_RADIUS / 3, Settings.BUTTON_RADIUS / 6);
		//graphics.lineTo( Settings.BUTTON_RADIUS / 3, Settings.BUTTON_RADIUS / 6);
	}
	
	public override function shapes() : void
	{
		// used for gloop collision
		box(GameSettings.BUTTON_RADIUS * 2, GameSettings.BUTTON_RADIUS / 3);
	}
	
	override public function create():void {
		super.create();
	}
}