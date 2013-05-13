package com.awaystudios.gloopahoop.gameobjects.components
{
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.*;
	
	public class WallPhysicsComponent extends PhysicsComponent
	{
		
		protected var _width : Number;
		protected var _height : Number;
		protected var _offsetX : Number;
		protected var _offsetY : Number;
		
		public function WallPhysicsComponent(gameObject : DefaultGameObject, offsetX : Number, offsetY : Number, width : Number, height : Number)
		{
			super(gameObject);

			_offsetX = offsetX-GameSettings.WALL_PADDING;
			_offsetY = offsetY-GameSettings.WALL_PADDING;
			_width = width+2*GameSettings.WALL_PADDING;
			_height = height+2*GameSettings.WALL_PADDING;

			graphics.beginFill(gameObject.debugColor1);
			graphics.drawRect(_offsetX, _offsetY, _width, _height);

			setStatic( true );
		}
		
		public override function shapes() : void
		{
			poly([
				[_offsetX, 			_offsetY],
				[_offsetX + _width, _offsetY],
				[_offsetX + _width, _offsetY + _height],
				[_offsetX, 			_offsetY + _height],
			]);	
		}
		
		override public function create() : void
		{
			super.create();
		}
	
	}

}