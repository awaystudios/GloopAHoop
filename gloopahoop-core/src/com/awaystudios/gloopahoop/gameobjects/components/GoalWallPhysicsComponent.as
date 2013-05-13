package com.awaystudios.gloopahoop.gameobjects.components
{
	
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.*;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GoalWallPhysicsComponent extends WallPhysicsComponent {
		
		public function GoalWallPhysicsComponent(gameObject:DefaultGameObject, offsetX:Number, offsetY:Number, width:Number, height:Number) {
			graphics.beginFill(gameObject.debugColor2);
			graphics.drawRect(offsetX, offsetY, width + GameSettings.GOALWALL_DETECTOR_WIDTH, height + GameSettings.GOALWALL_DETECTOR_HEIGHT);
			offsetX += GameSettings.WALL_PADDING;
			offsetY += GameSettings.WALL_PADDING;
			width -= 2*GameSettings.WALL_PADDING;
			height -= 2*GameSettings.WALL_PADDING;
			super(gameObject, offsetX, offsetY, width, height);
		}
		
		override protected function onBeginContact(e:ContactEvent):void {
			if (e.fixture == b2fixtures[1]) {
				var gloop:Gloop = getGloop(e.other);
				if (!gloop) return;
				GoalWall(_gameObject).onGloopEnterSensor(gloop);
				return;
			}
			
			super.onBeginContact(e);
		}
		
		override protected function onEndContact(e:ContactEvent):void {
			if (e.fixture == b2fixtures[1]) {
				var gloop:Gloop = getGloop(e.other);
				if (!gloop) return;
				GoalWall(_gameObject).onGloopExitSensor(gloop);
				return;
			}
			
			super.onEndContact(e);
		}
		
		override public function shapes():void {
			super.shapes();
			
			var w:Number = _width + GameSettings.GOALWALL_DETECTOR_WIDTH;
			var h:Number = _height + GameSettings.GOALWALL_DETECTOR_HEIGHT;
			
			poly([
				[_offsetX, 		_offsetY],
				[_offsetX + w,	_offsetY],
				[_offsetX + w, 	_offsetY + h],
				[_offsetX, 		_offsetY + h],
			]);	
		}
		
		override public function create():void {
			super.create();
			b2fixtures[1].SetSensor(true);
		}
		
	}

}