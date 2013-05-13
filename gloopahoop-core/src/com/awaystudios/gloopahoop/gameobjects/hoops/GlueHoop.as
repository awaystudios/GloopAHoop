package com.awaystudios.gloopahoop.gameobjects.hoops
{
	
	import Box2DAS.Dynamics.ContactEvent;
	
	import away3d.core.base.*;
	import away3d.library.*;
	
	import com.awaystudios.gloopahoop.gameobjects.*;
	import com.awaystudios.gloopahoop.gameobjects.components.*;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GlueHoop extends Hoop
	{
		
		private var _launcher:GloopLauncherComponent;
		
		public function GlueHoop(worldX : Number = 0, worldY : Number = 0, rotation : Number = 0, movable:Boolean = true, rotatable:Boolean = true)
		{
			super(0xffbe3f, worldX, worldY, rotation, movable, rotatable);
			_rotatable = false;
			_launcher = new GloopLauncherComponent(this);
		}
		
		override public function reset():void {
			super.reset();
			_launcher.reset();
		}
		
		public override function onCollidingWithGloopStart(gloop : Gloop, event:ContactEvent = null) : void
		{
			super.onCollidingWithGloopStart(gloop);
			_launcher.catchGloop(gloop);
		}
		
		override public function onDragUpdate(mouseX:Number, mouseY:Number):void {
			if (_launcher.gloop) {
				_launcher.onDragUpdate(mouseX, mouseY);
				return;
			}
			
			super.onDragUpdate(mouseX, mouseY); 
		}
		
		override public function onDragEnd(mouseX:Number, mouseY:Number):void {
			if (_launcher.gloop) {
				_launcher.onDragEnd(mouseX, mouseY);
				return;
			}
			
			super.onDragEnd(mouseX, mouseY);
		}
		
		override public function update(dt : Number) : void
		{
			super.update(dt);
			_launcher.update(dt);
		}
		
		
		protected override function getIconGeometry() : Geometry
		{
			return Geometry(AssetLibrary.getAsset('GlueIcon_geom'));
		}
		
		override public function get debugColor1() : uint
		{
			return 0x5F9E30;
		}
		
		override public function get debugColor2() : uint
		{
			return 0x436F22;
		}
	
	}

}