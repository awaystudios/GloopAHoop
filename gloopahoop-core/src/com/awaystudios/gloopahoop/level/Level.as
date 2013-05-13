package com.awaystudios.gloopahoop.level
{

	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.events.*;
	import com.awaystudios.gloopahoop.gameobjects.*;
	import com.awaystudios.gloopahoop.gameobjects.events.*;
	import com.awaystudios.gloopahoop.gameobjects.hoops.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	import away3d.containers.*
	import away3d.entities.*;
	import away3d.lights.*;
	import away3d.materials.lightpickers.*;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import wck.*;

	public class Level extends EventDispatcher
	{
		private var _scene : Scene3D;
		private var _world : World;
		
		private var _spawn_point :Point;
		private var _spawnDir : Number;
		
		private var _all_objects : Vector.<DefaultGameObject>;
		
		private var _target : GoalWall;
		
		private var _targetRotation : Number;
		
		private var _buttons : Vector.<Button>;
		private var _btn_controllables : Vector.<IButtonControllable>;
		
		private var _splattables : Vector.<Entity>;
		
		private var _mode:Boolean = EDIT_MODE;

		private var _bounds : Rectangle;
		
		private var _unplacedHoop:Hoop;
		
		private var _finishedWithBullseye : Boolean = false;
		
		private var _running : Boolean = true;
		private var _winDelayTimer:Timer;
		
		private var _cameraPointLight:PointLight;
		private var _sceneLightPicker:StaticLightPicker;
		
		public static const EDIT_MODE:Boolean = false;
		public static const PLAY_MODE:Boolean = true;
		
		
		public function Level()
		{
			_scene = new Scene3D();
			_world = new World();
			_world.timeStep = GameSettings.PHYSICS_TIME_STEP;
			_world.velocityIterations = GameSettings.PHYSICS_VELOCITY_ITERATIONS;
			_world.positionIterations = GameSettings.PHYSICS_POSITION_ITERATIONS;
			_world.gravityY = GameSettings.PHYSICS_GRAVITY_Y;
//			_world.dragMethod = 'Kinematic';
			_spawn_point = new Point();
			_all_objects = new Vector.<DefaultGameObject>();
			_btn_controllables = new Vector.<IButtonControllable>();
			_buttons = new Vector.<Button>();
			_splattables = new Vector.<Entity>;
			
			_winDelayTimer = new Timer(GameSettings.WIN_DELAY, 1);
			_winDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onWinDelayTimerComplete);
			
			_cameraPointLight = new PointLight();
			_cameraPointLight.specular = 0;
			_cameraPointLight.ambient = 0.4;

			_sceneLightPicker = new StaticLightPicker( [ _cameraPointLight ] );
			
			_bounds = new Rectangle();
		}
		
		public function setMode(value:Boolean, force:Boolean = false):void {
			if (!force && value == _mode) return;
			
//			trace("Level, set mode: " + (value ? "play" : "edit"));
			_mode = value;
			for each(var object:DefaultGameObject in _all_objects) {
				object.setMode(value);
			}
		}
		
		public function queueHoopForPlacement(unplacedHoop:Hoop):void {
			_unplacedHoop = unplacedHoop;
		}
		
		public function placeQueuedHoop(worldX:Number, worldY:Number):void {
			add(_unplacedHoop);
			_unplacedHoop.physics.moveTo(worldX, worldY);
			_unplacedHoop = null;
		}
		
		/**
		 * Returns the nearest hoop to the supplied coordinates assuming it is closer than INPUT_PICK_DISTANCE
		 * @param	mouseX
		 * @param	mousey
		 * @return
		 */
		public function getNearestIMouseInteractive(worldX : Number, worldY : Number) : IMouseInteractive
		{
			var object : IMouseInteractive;
			var nearest : IMouseInteractive;
			var dist : Number = 0;
			var nearestDist : Number = GameSettings.INPUT_PICK_DISTANCE;
			var mousePos : Point = new Point(worldX, worldY);
			var objectPos : Point = new Point;
			
			for (var i : int = 0; i < _all_objects.length; i++)
			{
				object = _all_objects[i] as IMouseInteractive;
				if (!object)
					continue;
				
				
				
				if (object is Cannon)
				{
					objectPos.x = object.physics.x + Math.cos((-90+object.physics.rotation)*Math.PI/180)*GameSettings.INPUT_CANNON_LENGTH;
					objectPos.y = object.physics.y + Math.sin((-90+object.physics.rotation)*Math.PI/180)*GameSettings.INPUT_CANNON_LENGTH;
					
					dist = Point.distance(mousePos, objectPos);
					
					if (dist < nearestDist && dist < GameSettings.INPUT_CANNON_DISTANCE)
					{
						nearestDist = dist;
						nearest = object;
					}
					continue;
				}
				
				objectPos.x = object.physics.x;
				objectPos.y = object.physics.y;
				
				dist = Point.distance(mousePos, objectPos);
				
				if (dist < nearestDist)
				{
					nearestDist = dist;
					nearest = object;
				}
			}
			
			return nearest;
		}
		
		public function get target() : GoalWall
		{
			return _target;
		}
		
		public function get targetRotation() : Number
		{
			return _targetRotation;
		}
		
		public function get spawnPoint() : Point
		{
			return _spawn_point;
		}
		
		public function get spawnAngle() : Number
		{
			return _spawnDir;
		}
		public function set spawnAngle(val : Number) : void
		{
			_spawnDir = val;
		}
		
		public function get scene() : Scene3D
		{
			return _scene;
		}
		
		public function get world() : World
		{
			return _world;
		}		
		
		public function get splattableMeshes() : Vector.<Entity>
		{
			return _splattables;
		}
		
		public function get objects():Vector.<DefaultGameObject> {
			return _all_objects;
		}
		
		public function add(object:DefaultGameObject):DefaultGameObject {
			_all_objects.push(object);
			
			object.setLightPicker(_sceneLightPicker);
			
			if (object.physics)
				world.addChild(object.physics);
			
			if (object.meshComponent)
				_scene.addChild(object.meshComponent.mesh);

			if (object is Button) {
				_buttons.push(Button(object));
			}
			else if (object is IButtonControllable) {
				_btn_controllables.push(IButtonControllable(object));
			}
			
			// Special cases for Gloop
			if (object is Gloop) {
				var gloop : Gloop = Gloop(object);
				
				_scene.addChild(gloop.traceComponent.pathTracer);
			}
			else if (object is GoalWall) {
				_target = object as GoalWall;
				_targetRotation = object.physics.rotation;
			}

			object.addEventListener(GameObjectEvent.LAUNCHER_CATCH_GLOOP, onLauncherCatchGloop);
			object.addEventListener(GameObjectEvent.LAUNCHER_FIRE_GLOOP, onLauncherFireGloop);
			object.addEventListener(GameObjectEvent.GLOOP_HIT_GOAL_WALL, onHitGoalWall);
			object.addEventListener(GameObjectEvent.GLOOP_LOST_MOMENTUM, onGloopLostMomentum);
			object.addEventListener(GameObjectEvent.GLOOP_COLLECT_STAR, onGloopCollectStar);
			object.addEventListener(GameObjectEvent.HOOP_REMOVE, onHoopRemove);

			return object;
		}
		
		
		public function addStatic(obj : ObjectContainer3D) : void
		{
			if (obj is Mesh) {
				var mesh : Mesh = Mesh(obj);
				if (GameSettings.STU_MODE)
					mesh.material.lightPicker = _sceneLightPicker;
			}
			
			_scene.addChild(obj);
		}
		
		
		/**
		 * Removes and disposes of an object. The object will not be usable after this.
		 * @param	object	the object to remove
		 * @return	true if object was removed, false if it could not be found
		 */
		private function remove(object:DefaultGameObject):Boolean {
			var index:int = _all_objects.indexOf(object);
			if (index < 0) return false;
			_all_objects.splice(index, 1);
			disposeObject(object);
			return true;
		}

		public function setup() : void
		{
			var btn : Button;

			for each (btn in _buttons) {
				var i : uint;

				for (i=0; i<_btn_controllables.length; i++) {
					if (_btn_controllables[i].buttonGroup == btn.buttonGroup)
						btn.addControllable(_btn_controllables[i]);
				}
			}
		}


		public function update() : void
		{
			if (!_running) return;
			
			_world.step();
			
			var i : uint;
			for (i=0; i<_all_objects.length; i++) {
				_all_objects[i].update(1);
			}
		}


		public function dispose() : void
		{
			var obj : DefaultGameObject;
			
			while (obj = _all_objects.pop()) {
				disposeObject(obj);
			}			
		}
		
		public function disposeObject( obj : DefaultGameObject ):void {

			if (obj.meshComponent && obj.meshComponent.mesh && obj.meshComponent.mesh.parent) {
				obj.meshComponent.mesh.parent.removeChild( obj.meshComponent.mesh );
			}

			if (obj.physics && obj.physics.parent){
				obj.physics.parent.removeChild(obj.physics);
				obj.physics.destroy();
			}

			obj.removeEventListener(GameObjectEvent.LAUNCHER_CATCH_GLOOP, onLauncherCatchGloop);
			obj.removeEventListener(GameObjectEvent.LAUNCHER_FIRE_GLOOP, onLauncherFireGloop);
			obj.removeEventListener(GameObjectEvent.GLOOP_HIT_GOAL_WALL, onHitGoalWall);
			obj.removeEventListener(GameObjectEvent.GLOOP_LOST_MOMENTUM, onGloopLostMomentum);
			obj.removeEventListener(GameObjectEvent.HOOP_REMOVE, onHoopRemove);
			
			obj.dispose();
		}

		/**
		 * Resets the level to its "pre-play" state, player edits are maintaned, but any toggled items are reset, launchers reloaded and so on
		 */
		public function reset(full : Boolean = false):void {
			for each(var object:DefaultGameObject in _all_objects) {
				object.reset();
			}
			_running = true;
			_winDelayTimer.reset();
			setMode(Level.EDIT_MODE, true);
		}


		private function win() : void
		{
			SoundManager.stop( SoundManager.CHANNEL_FAN );
			_running = false;
			_winDelayTimer.reset();
			_winDelayTimer.start();
		}


		private function lose() : void
		{
			SoundManager.stop( SoundManager.CHANNEL_FAN );
			dispatchEvent(new GameEvent(GameEvent.LEVEL_LOSE));
		}
		
		private function onLauncherCatchGloop(e:GameObjectEvent):void {
			setMode(Level.EDIT_MODE);
		}
		
		private function onLauncherFireGloop(e:GameObjectEvent):void {
			setMode(Level.PLAY_MODE);
		}
		
		private function onHitGoalWall(e:GameObjectEvent):void {
			var goalWall:GoalWall = e.target as GoalWall;
			if (goalWall && goalWall.splatDistance < GameSettings.GOALWALL_BULLSEYE_THRESHOLD) {
				_finishedWithBullseye = true;
				SoundManager.playRandomWithDelay( [ Sounds.GLOOP_GIGGLE, Sounds.GLOOP_GIGGLE1, Sounds.GLOOP_GIGGLE2, Sounds.GLOOP_GIGGLE3, Sounds.GLOOP_GIGGLE4 ], rand( 0.5, 1 ) );
			} else {
				_finishedWithBullseye = false;
			}
			win();
		}

		private function rand(min:Number, max:Number):Number
		{
			return (max - min)*Math.random() + min;
		}
		
		private function onGloopLostMomentum(e:GameObjectEvent):void {
			lose();
		}
		
		private function onGloopCollectStar(e:GameObjectEvent):void {
			dispatchEvent(new GameEvent(GameEvent.LEVEL_STAR_COLLECT));
		}
		
		private function onHoopRemove(e:GameObjectEvent):void {
//			trace("New hoop placed inside wall, removing it");
			remove(e.gameObject);
		}
		
		private function onWinDelayTimerComplete(e:TimerEvent):void {
			dispatchEvent(new GameEvent(GameEvent.LEVEL_WIN)); // comment to stop game from automatically going to the win screen
		}
		
		public function get camLightX() : Number
		{
			return _cameraPointLight.x;
		}
		public function set camLightX(val : Number) : void
		{
			_cameraPointLight.x = val;
		}
		
		
		public function get camLightY() : Number
		{
			return _cameraPointLight.y;
		}
		public function set camLightY(val : Number) : void
		{
			_cameraPointLight.y = val;
		}
		
		
		public function get camLightZ() : Number
		{
			return _cameraPointLight.z;
		}
		public function set camLightZ(val : Number) : void
		{
			_cameraPointLight.z = val;
		}
		

		public function get bounds() : Rectangle
		{
			return _bounds;
		}
		
		public function get unplacedHoop():Hoop {
			return _unplacedHoop;
		}
		
		public function get finishedWithBullseye():Boolean {
			return _finishedWithBullseye;
		}
	}
}
