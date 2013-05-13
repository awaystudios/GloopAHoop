package com.awaystudios.gloopahoop.gameobjects
{

	
	import Box2DAS.Dynamics.ContactEvent;
	
	import away3d.materials.lightpickers.*;
	
	import com.awaystudios.gloopahoop.gameobjects.components.*;
	import com.awaystudios.gloopahoop.level.*;

	public class DefaultGameObject extends GameObject
	{
		protected var _mode:Boolean;
		protected var _meshComponent : MeshComponent;
		protected var _physics : PhysicsComponent;

		public function DefaultGameObject()
		{
			super();
		}
		
		public override function update(dt:Number):void
		{
			if (_meshComponent && _physics) {
				_meshComponent.mesh.x = _physics.x;
				_meshComponent.mesh.y = -_physics.y;
				_meshComponent.mesh.rotationZ = -physics.rotation;
			}
		}
		
		public function setMode(value:Boolean):void {
			_mode = value;
		}
		
		public function setLightPicker(picker : LightPickerBase) : void
		{
			if (_meshComponent)
				_meshComponent.setLightPicker(picker);
		}
		
		public function get physics():PhysicsComponent {
			return _physics;
		}
		
		public function get meshComponent():MeshComponent {
			return _meshComponent;
		}
		
		public function get debugColor1():uint {
			return 0xff0000;
		}
		
		public function get debugColor2():uint {
			return 0x00ff00;
		}
		
		public function get inEditMode():Boolean {
			return _mode == Level.EDIT_MODE;
		}

		public function reset():void {

		}

		public function onCollidingWithSomethingStart( event:ContactEvent ):void {
			// override
		}

		public function onCollidingWithSomethingEnd( event:ContactEvent ):void {
			// override
		}

		public function onCollidingWithSomethingPreSolve( event:ContactEvent ):void {
			// override
		}

		public function onCollidingWithGloopStart(gloop:Gloop, event:ContactEvent = null ):void {
			// override
		}

		public function onCollidingWithGloopEnd(gloop:Gloop, event:ContactEvent = null ):void {
			// override
		}

		public function onCollidingWithGloopPreSolve( gloop:Gloop, event:ContactEvent = null ):void {
			// override
		}
	}
}