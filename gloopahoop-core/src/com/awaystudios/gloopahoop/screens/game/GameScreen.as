package com.awaystudios.gloopahoop.screens.game
{

	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.events.*;
	import com.awaystudios.gloopahoop.gameobjects.*;
	import com.awaystudios.gloopahoop.gameobjects.events.*;
	import com.awaystudios.gloopahoop.hud.*;
	import com.awaystudios.gloopahoop.input.*;
	import com.awaystudios.gloopahoop.level.*;
	import com.awaystudios.gloopahoop.screens.*;
	import com.awaystudios.gloopahoop.screens.game.controllers.*;
	import com.awaystudios.gloopahoop.sounds.*;
	import com.awaystudios.gloopahoop.utils.*;
	
	import away3d.containers.*;
	
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.*;
	
	import wck.*;

	public class GameScreen extends ScreenBase
	{
		private var _db:LevelDatabase;
		private var _stack : ScreenStack;
		private var _level : Level;
		private var _levelProxy:LevelProxy;
		
		private var _paused : Boolean;
		private var _pauseOverlay : PauseOverlay;
		
		private var _cameraController : CameraController;
		private var _editController : LevelEditController;

		private var _gloop:Gloop;
		private var _cannon:Cannon;

		private var _doc:WCK;
		private var _view:View3D;
		private var _inputManager:InputManager;
		
		private var _hud : HUD;
		private var _timestep:Timestep;
		
		private var _firstReset : Boolean;
		private var _panLevel:Boolean;
		private var _panTimer:int;
		private var _alphaTimer:int;
		
		private static var _instance:GameScreen;

		public function GameScreen( db:LevelDatabase, stack : ScreenStack, view : View3D ) {
			super( false );
			mouseEnabled = false;
			
			_db = db;
			_stack = stack;
			_view = view;
			
			_musicTheme = Themes.IN_GAME_THEME;

			addEventListener( Event.ADDED_TO_STAGE, stageInitHandler );

			_instance = this;
		}

		private function stageInitHandler(evt:Event):void
		{
		    removeEventListener( Event.ADDED_TO_STAGE, stageInitHandler );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, stageKeyDownHandler );
		}

		private function stageKeyDownHandler( event:KeyboardEvent ):void {

			if( !_active ) return;

			switch( event.keyCode ) {
				case Keyboard.SPACE :

					_levelProxy.reset();

					break;
			}
		}

		protected override function initScreen():void
		{
			initWorld();
			initHUD();
			initPersistantObjects();
			initControllers();
		}

		private function initWorld() : void
		{
			_doc = new WCK();
			_doc.scaleX = 0.2;
			_doc.scaleY = 0.2;
			_doc.visible = GameSettings.SHOW_PHYSICS;
			_doc.addEventListener( MouseEvent.MOUSE_DOWN, docMouseDownHandler );
			_doc.addEventListener( MouseEvent.MOUSE_UP, docMouseUpHandler );
			addChild( _doc );
		}

		private function docMouseUpHandler( event:MouseEvent ):void {
			_doc.stopDrag();
		}

		private function docMouseDownHandler( event:MouseEvent ):void {
			_doc.startDrag();
		}

		private function initHUD() : void
		{
			_hud = new HUD(_w, _h);
			addChild(_hud);
			
			_pauseOverlay = new PauseOverlay(_w, _h);
			_pauseOverlay.resumeButton.addEventListener(MouseEvent.CLICK, onPauseOverlayResumeButtonClick);
			_pauseOverlay.mainMenuButton.addEventListener(MouseEvent.CLICK, onPauseOverlayMainMenuButtonClick);
			_pauseOverlay.levelSelectButton.addEventListener(MouseEvent.CLICK, onPauseOverlayLevelSelectButtonClick);
		}
		
		
		private function initPersistantObjects() : void
		{
			_gloop = new Gloop(0, 0);
			_gloop.addEventListener( GameObjectEvent.GLOOP_APPROACH_GOAL_WALL, onGloopApproachGoalWall);
			_gloop.addEventListener( GameObjectEvent.GLOOP_MISSED_GOAL_WALL, onGloopMissedGoalWall);
			_gloop.addEventListener( GameObjectEvent.GLOOP_FIRED, onGloopFired );
			
			_cannon = new Cannon();
		}
		
		
		private function initControllers() : void
		{
			_inputManager = new InputManager(_view);
			_cameraController = new CameraController(_inputManager, _view.camera, _gloop);
			_editController = new LevelEditController();
		}
		
		public override function activate():void {
			super.activate();

			_view.render();
			
			_timestep = new Timestep( 60 );

			_levelProxy = _db.selectedLevelProxy;

			_level = _levelProxy.level;
			
			_levelProxy.addEventListener(GameEvent.LEVEL_RESET, onLevelReset);
			_levelProxy.addEventListener(GameEvent.GAME_PAUSE, onLevelProxyPause);
			_levelProxy.addEventListener(GameEvent.GAME_RESUME, onLevelProxyResume);
				
			_doc.addChild( _level.world );
			_doc.x = _doc.width / 2;
			_doc.y = stage.stageHeight - _doc.height / 2;

			_view.scene = new Scene3D(); // insert a dummy visual scene while level is being built
			
			// Camera must be in scene since it needs to update
			// for the HUD to update accordingly.
			_view.scene.addChild(_view.camera);
			
			_editController.activate(_levelProxy);

			_inputManager.reset(_level);
			_inputManager.activate();
			
			_cannon.physics.moveTo(_level.spawnPoint.x, _level.spawnPoint.y);
			_level.add(_cannon);

			_inputManager.mouseDummy.resetColliders();
			_level.add( _inputManager.mouseDummy );

			_gloop.traceComponent.pathTracer.reset();
			_gloop.setSpawn( _level.spawnPoint.x, _level.spawnPoint.y );
			_gloop.splatComponent.splattables = _level.splattableMeshes;

			_cameraController.setBounds(
				_level.bounds.left,
				_level.bounds.right,
				_level.bounds.top,
				_level.bounds.bottom);
			_cameraController.setGloopIdle();

			_firstReset = true;
			
			// TODO : This is a hack to not make the launcher collide with gloop on spawn (and thus remove itself). I'll fix this later /Martin
			setTimeout(function():void {
				_level.add(_gloop);
				_levelProxy.reset();

				// Apply nice lighting.
				// TODO: Don't affect HUD
				/*
				for( var i:uint, len:uint = _level.scene.numChildren; i < len; ++i ) {
					HierarchyTool.recursiveApplyLightPicker( _level.scene.getChildAt( i ), _sceneLightPicker );
				}
				*/
			}, 200);

			// wait a bit to allow scene rendering ( while level is being built )
			setTimeout( function():void {
				_view.scene = _level.scene;
			}, 500 )
		}

		private function reset():void
		{
			_gloop.meshComponent.mesh.visible = false;

			_hud.reset(_levelProxy);

			if (_firstReset) {
				// Reset both position and cannon aim angle
				_cannon.spawnGloop(_gloop, _level.spawnAngle);
				_firstReset = false;
				_cameraController.firstReset();
				
				if( !_inputManager.panInternallyChanged ) {
					_inputManager.panX = _level.target.physics.x;
					_inputManager.panY = -_level.target.physics.y;
				}
				
				_panLevel = true;
				_panTimer = 0;
				_alphaTimer = 0;
				_hud.levelTitles.gotoAndStop(_levelProxy.idx+1);
			}
			else {
				// Start back in cannon, but don't change it's angle
				_cannon.spawnGloop(_gloop);
				if( !_inputManager.panInternallyChanged ) {
					_inputManager.panX = _gloop.physics.x;
					_inputManager.panY = -_gloop.physics.y;
				}
				
				if (_panTimer < 225)
					_panTimer = 225;
			}

			_cameraController.setGloopIdle();
			_cameraController.resetOrientation();
			_inputManager.reset(_level);

			if (_paused) {
				_paused = false;
				if( _pauseOverlay.parent == this ) removeChild(_pauseOverlay);
			}
		}

		public override function deactivate():void
		{
			super.deactivate();
			_inputManager.deactivate();
			_editController.deactivate();
			
			_levelProxy.removeEventListener(GameEvent.LEVEL_RESET, onLevelReset);
			_levelProxy.removeEventListener(GameEvent.GAME_PAUSE, onLevelProxyPause);
			_levelProxy.removeEventListener(GameEvent.GAME_RESUME, onLevelProxyResume);
			
			_view.scene = new Scene3D();
			
			_hud.levelTitles.visible = false;
			_hud.helpText.visible = false;
		}
		
		private function onGloopApproachGoalWall(ev : GameObjectEvent) : void
		{
			_cameraController.setGloopFinishing(_level.targetRotation * Math.PI/180);
		}
		
		private function onGloopMissedGoalWall(ev : GameObjectEvent) : void
		{
			// Return to regular fired mode.
			_cameraController.setGloopMissed();
		}

		private function onGloopFired( event:GameObjectEvent ):void {
			_gloop.meshComponent.mesh.visible = true;
			_cameraController.setGloopFired(
				_view.camera.x - _gloop.physics.x,
				_view.camera.y + _gloop.physics.y);
		}

		private function onLevelReset(event : GameEvent):void
		{
			reset();
		}
		
		
		private function onLevelProxyPause(ev : GameEvent) : void
		{
			_paused = true;
			addChild(_pauseOverlay);
		}
		
		
		private function onLevelProxyResume(ev : GameEvent) : void
		{
			if (_paused) {
				_paused = false;
				removeChild(_pauseOverlay);
			}
		}
		
		
		private function onPauseOverlayResumeButtonClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_levelProxy.resume();
		}
		
		private function onPauseOverlayMainMenuButtonClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stack.gotoScreen(Screens.START);
			if( _pauseOverlay.parent == this ) removeChild(_pauseOverlay);
		}
		
		private function onPauseOverlayLevelSelectButtonClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stack.gotoScreen(Screens.LEVELS);
			if( _pauseOverlay.parent == this ) removeChild(_pauseOverlay);
		}
		

		override protected function update():void
		{
			if (!_paused) {
				_timestep.tick();
				var updates:int = _timestep.steps;

				while (updates-- > 0) {
					if( _level ) _level.update();
					_cameraController.update();
				}
				
				if (_level) {
					_level.camLightX = _view.camera.x;
					_level.camLightY = _view.camera.y;
					_level.camLightZ = _view.camera.z;
				}
				
				if (_panLevel) {
					
					if (_inputManager.mouseInteracted && _hud.levelTitles.visible && _alphaTimer)
						_alphaTimer--;
					
					if (_inputManager.panInternallyChanged && _panTimer < 225) {
						_panTimer = 225;
					}
					
					_panTimer += 1;
					
					if (_panTimer > 250) {
						_panLevel = false;
					} else if (_panTimer > 225) {
						//fade out
						if (_alphaTimer >  25 - (_panTimer - 225))
							_alphaTimer =  25 - (_panTimer - 225)
					} else if (_panTimer > 25) {
						//pan
						var fract:Number = (_panTimer - 25)/200;
						_inputManager.panX = _level.target.physics.x + fract*(_gloop.physics.x - _level.target.physics.x);
						_inputManager.panY = -_level.target.physics.y - fract*(_gloop.physics.y - _level.target.physics.y);
					} else {
						//fade in
						_hud.levelTitles.visible = true;
						_alphaTimer++;
					}
					
					if (!_alphaTimer) {
						if (_levelProxy.helpId && _hud.levelTitles.visible)
						{
							_hud.helpText.visible = true;
							_hud.helpText.gotoAndStop(_levelProxy.helpId);
						}
						
						_hud.levelTitles.visible = false;
					}
					
					_hud.levelTitles.alpha = _alphaTimer/25;
				}
				
			}
		}

		public static function get instance():GameScreen {
			return _instance;
		}

		public function get view():View3D {
			return _view;
		}
	}
}
