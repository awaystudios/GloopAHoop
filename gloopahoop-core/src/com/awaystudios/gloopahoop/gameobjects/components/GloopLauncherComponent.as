package com.awaystudios.gloopahoop.gameobjects.components
{
	
	import Box2DAS.Common.V2;
	
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.*;
	import com.awaystudios.gloopahoop.gameobjects.events.*;
	
	import flash.geom.*;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GloopLauncherComponent {
		
		private var _gloop : Gloop;		
		private var _aim : Point;
		private var _fired : Boolean = false;
		private var _gameObject:DefaultGameObject;
		
		public function GloopLauncherComponent(gameObject:DefaultGameObject) {
			_gameObject = gameObject;
			_aim = new Point( -1, -1);
		}
		
		public function reset():void {
			_fired = false;
		}
		
		public function catchGloop(gloop:Gloop):void {
			if (_fired) return;	// don't catch the gloop if we've fired once already
			_gloop = gloop; // catch the gloop
			_gameObject.dispatchEvent(new GameObjectEvent(GameObjectEvent.LAUNCHER_CATCH_GLOOP, _gameObject));
		}
		
		public function onDragUpdate(mouseX:Number, mouseY:Number):void {
			if (_fired) return; // if hoop has fired, disable movement
			if (!_gloop) return;
			
			var hoopPos:V2 = _gameObject.physics.b2body.GetPosition();
			_aim.x = hoopPos.x * GameSettings.PHYSICS_SCALE - mouseX;
			_aim.y = hoopPos.y * GameSettings.PHYSICS_SCALE - mouseY;
			
			updateAim(hoopPos);
		}
		
		public function onDragEnd(mouseX:Number, mouseY:Number):void {
			if (!_gloop) return;
			if (!shotPowerAboveThreshold) return;
			launch();
		}
		
		private function launch() : void
		{
			if (!_gloop)
				return; // can't fire if not holding the gloop
			
			var impulse : V2 = _gameObject.physics.b2body.GetWorldVector(new V2(0, shotPower));
			_gloop.physics.b2body.ApplyImpulse(impulse, _gameObject.physics.b2body.GetWorldCenter());
			
			_gloop.onLaunch();
			
			_gloop = null; // release the gloop
			_fired = true;
			
			_gameObject.dispatchEvent(new GameObjectEvent(GameObjectEvent.LAUNCHER_FIRE_GLOOP, _gameObject));
		}
		
		public function updateAim(hoopPos:V2 = null):void {
			hoopPos ||= _gameObject.physics.b2body.GetPosition();
			_gameObject.physics.b2body.SetTransform(hoopPos, -Math.atan2(_aim.x, _aim.y));
			_gameObject.physics.updateBodyMatrix(null);
		}
		
		public function update(dt:Number):void {
			if (!_gloop) return;
			if (!_gloop.physics.b2body) return; // gloop hasn't inited its physics yet, wait for a bit
			_gloop.physics.b2body.SetLinearVelocity(new V2(0, 0)); // kill incident velocity
			_gloop.physics.b2body.SetTransform(_gameObject.physics.b2body.GetPosition(), 0); // position gloop on top of launcher
		}
		
		public function get shotPowerAboveThreshold():Boolean {
			return _aim.length > GameSettings.LAUNCHER_DRAG_MIN;
		}
		
		public function get shotPowerNormalized():Number {
			var power:Number = Math.min(_aim.length, GameSettings.LAUNCHER_DRAG_MAX);
			power = Math.max(0, (power - GameSettings.LAUNCHER_DRAG_MIN) / (GameSettings.LAUNCHER_DRAG_MAX - GameSettings.LAUNCHER_DRAG_MIN));
			return power;
			//return Quad.easeIn(power, 0, 1, 1);
		}
		
		public function get shotPower():Number {
			return ( GameSettings.LAUNCHER_POWER_BASE + shotPowerNormalized * GameSettings.LAUNCHER_POWER_VARIATION );
		}
		
		public function get gloop():Gloop {
			return _gloop;
		}
		
		public function get aim():Point {
			return _aim;
		}
		
		public function get fired():Boolean {
			return _fired;
		}
		
	}

}