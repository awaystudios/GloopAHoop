package com.awaystudios.gloopahoop
{
	import com.away3d.gloop.lib.sounds.game.*;
	import com.away3d.gloop.lib.sounds.gloop.*;
	import com.away3d.gloop.lib.sounds.menu.*;
	import com.away3d.gloop.lib.sounds.music.*;
	import com.awaystudios.gloopahoop.events.*;
	import com.awaystudios.gloopahoop.level.*;
	import com.awaystudios.gloopahoop.screens.*;
	import com.awaystudios.gloopahoop.screens.chapterselect.*;
	import com.awaystudios.gloopahoop.screens.game.*;
	import com.awaystudios.gloopahoop.screens.levelselect.*;
	import com.awaystudios.gloopahoop.screens.settings.*;
	import com.awaystudios.gloopahoop.screens.win.*;
	import com.awaystudios.gloopahoop.sounds.*;
	import com.awaystudios.gloopahoop.utils.*;
	
	import away3d.containers.*;
	import away3d.debug.*;
	import away3d.entities.*;
	import away3d.library.*;
	import away3d.library.assets.*;
	import away3d.library.utils.*;
	import away3d.loaders.parsers.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	
	public class GameContainer extends Sprite
	{
		private var _awdParser:AWDParser = new AWDParser();
		
		private var _3dsParser:Max3DSParser = new Max3DSParser(false);
		
		//engine variables
		private var _view : View3D;
		
		private var _queue : AssetLoaderQueue;
		
		private var _db:LevelDatabase;
		private var _stack:ScreenStack;
		private var _settings:SettingsLoader;
		private var _stats:AwayStats;
		private var _stackHolder:Sprite;
		private var _gloopahoop : GameController;
		
		protected var _saveStateManager : SaveStateManager;
		protected var _stageProperties : StageProperties;
		
		public function GameContainer(saveStateManager:SaveStateManager)
		{
			_saveStateManager = saveStateManager;
			
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
			
			initGlobal();
			initEngine();
			initSettings();
			initDb();
			initSound();
			initMusic();
			initListeners();
			
			initStack();
			initAssets();
		}
		
		/**
		 * Initialise the global settings of the game
		 */		
		protected function initGlobal():void
		{
			//set stage properties
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			_stageProperties = new StageProperties();
			
			//determine the platform we are running on (used for screen dimension variables)
			var man:String = Capabilities.manufacturer;
			_stageProperties.isDesktop = (man.indexOf('Win')>=0 || man.indexOf('Mac')>=0);
		}
		
		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{
			//setup the 3d view
			_view = new View3D();
			_view.addSourceURL("srcview/index.html");
			_view.camera.lens.near = 50;
			_view.camera.lens.far = 100000;
			_view.camera.z = -2000;
			addChild( _view );
			
			// add awaystats if in debug mode
			if( GameSettings.DEV_MODE ) {
				addChild( new AwayStats( _view ) );
				_view.scene.addChild( new Trident() );
			}
		}
		
		private function initAssets() : void
		{
			AssetLibrary.enableParser( AWD2Parser );
			
			_stack.gotoScreen(Screens.LOADING);
			
			_queue = new AssetLoaderQueue();
			
			_queue.addResource(EmbeddedResources.FlyingAWDAsset, _awdParser);
			_queue.addResource(EmbeddedResources.GloopSplat3DSAsset, _3dsParser);
			_queue.addResource(EmbeddedResources.Cannon3DSAsset, _3dsParser);
			_queue.addResource(EmbeddedResources.Fan3DSAsset, _3dsParser);
			_queue.addResource(EmbeddedResources.Button3DSAsset, _3dsParser);
			_queue.addResource(EmbeddedResources.Target3DSAsset, _3dsParser);
			_queue.addResource(EmbeddedResources.Star3DSAsset, _3dsParser);
			_queue.addResource(EmbeddedResources.Hoop3DSAsset, _3dsParser);
			_queue.addResource(EmbeddedResources.Box3DSAsset, _3dsParser);
			_queue.addResource(EmbeddedResources.Monitor3DSAsset, _3dsParser);
			_queue.addEventListener(Event.COMPLETE, onAssetsComplete);
			_queue.load();
		}
		
		private function initSettings():void {
			_settings = new SettingsLoader(GameSettings);
		}
		
		private function initDb():void {
			_db = new LevelDatabase();
			_db.addEventListener( Event.COMPLETE, onDbComplete );
			_db.addEventListener( GameEvent.CHAPTER_SELECT, onDbChapterSelect );
			_db.addEventListener( GameEvent.LEVEL_SELECT, onDbLevelSelect );
			_db.addEventListener( GameEvent.LEVEL_LOSE, onDbLevelLose );
			_db.addEventListener( GameEvent.LEVEL_WIN, onDbLevelWin );
		}
		
		
		private function initStack():void {
			_stackHolder = new Sprite();
			_stackHolder.mouseEnabled = false;
			addChild( _stackHolder );
			_stack = new ScreenStack(_stageProperties, _stackHolder );
			_stack.addScreen( Screens.LOADING, new LoadingScreen() );
			_stack.addScreen( Screens.START, new StartScreen(_stack) );
			_stack.addScreen( Screens.SETTINGS, new SettingsScreen(_db, _stack, _saveStateManager) );
			_stack.addScreen( Screens.GAME, new GameScreen(_db, _stack, _view));
			_stack.addScreen( Screens.CHAPTERS, new ChapterSelectScreen( _db, _stack ) );
			_stack.addScreen( Screens.LEVELS, new LevelSelectScreen( _db, _stack ) );
			_stack.addScreen( Screens.WIN, new WinScreen(_db, _stack) );
			_stack.addScreen( Screens.ASSET_INITIALIZE, new AssetInitializeScreen( _view ) );
			_stack.addScreen( Screens.GAME_WIN, new GameWinScreen( _stack ) );
		}
		
		
		private function initSound() : void
		{
			SoundManager.addSound(Sounds.GAME_BUTTON, new ButtonSound());
			SoundManager.addSound(Sounds.GAME_CANNON, new CannonSound());
			SoundManager.addSound(Sounds.GAME_SPLAT, new SplatSound());
			SoundManager.addSound(Sounds.GAME_STAR, new StarSound());
			SoundManager.addSound(Sounds.GAME_BOING, new BoingSound());
			SoundManager.addSound(Sounds.MENU_BUTTON, new MenuButtonSound());
			SoundManager.addSound(Sounds.GLOOP_WOOO, new GloopWoooSound());
			SoundManager.addSound(Sounds.GLOOP_WALL_HIT_1, new GloopWallHit1());
			SoundManager.addSound(Sounds.GLOOP_WALL_HIT_2, new GloopWallHit2());
			SoundManager.addSound(Sounds.GLOOP_WALL_HIT_3, new GloopWallHit3());
			SoundManager.addSound(Sounds.GLOOP_WALL_HIT_4, new GloopWallHit4());
			SoundManager.addSound(Sounds.GLOOP_TRAMPOLINE_HIT, new GloopTrampolineHit());
			SoundManager.addSound(Sounds.GLOOP_BUTTON_HIT, new GloopButtonHit());
			SoundManager.addSound(Sounds.GLOOP_CATAPULTED, new GloopCatapulted());
			SoundManager.addSound(Sounds.GLOOP_GIGGLE, new GloopGiggle());
			SoundManager.addSound(Sounds.GLOOP_GIGGLE1, new GloopGiggle1());
			SoundManager.addSound(Sounds.GLOOP_GIGGLE2, new GloopGiggle2());
			SoundManager.addSound(Sounds.GLOOP_GIGGLE3, new GloopGiggle3());
			SoundManager.addSound(Sounds.GLOOP_GIGGLE4, new GloopGiggle4());
			SoundManager.addSound(Sounds.GLOOP_DIS1, new GloopDis1());
			SoundManager.addSound(Sounds.GLOOP_DIS2, new GloopDis2());
			SoundManager.addSound(Sounds.GLOOP_DIS3, new GloopDis3());
			SoundManager.addSound(Sounds.GLOOP_DIS4, new GloopDis4());
			SoundManager.addSound(Sounds.GAME_TRAMPOLINE, new TrampolineSound());
			SoundManager.addSound(Sounds.GAME_ROCKET, new RocketSound());
			SoundManager.addSound(Sounds.GAME_FAN, new FanSound());
		}
		
		
		private function initMusic():void {
			MusicManager.addTheme( Themes.IN_GAME_THEME, new InGameMusicSound() );
			MusicManager.addTheme( Themes.MAIN_THEME, new ThemeMusicSound() );
		}
		
		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			stage.addEventListener( Event.RESIZE, onResize);
			stage.addEventListener( Event.ENTER_FRAME, onEnterFrame);
			onResize();
		}
		private function onAssetsComplete(ev : Event) : void
		{
			var it : AssetLibraryIterator;
			var mesh : Mesh;
			
			// Get rid of meshes to avoid having to clone geometries
			// to circumvent issues with material/animation sharing.
			it = AssetLibrary.createIterator(AssetType.MESH);
			while (mesh = Mesh(it.next())) {
				AssetLibrary.removeAsset(mesh, false);
				mesh.material = null;
				mesh.geometry = null;
				mesh.dispose();
			}
			
			// force animation and asset initialization
			_stack.getScreenById( Screens.ASSET_INITIALIZE ).addEventListener( Event.COMPLETE, onGameScreenAnimationsInitialized ); // uncomment to see 3D asset init screen ( 1/2 )
			_stack.gotoScreen( Screens.ASSET_INITIALIZE );
			_stack.gotoScreen( Screens.LOADING ); // uncomment to see 3D asset init screen ( 2/2 )
		}
		
		private function onGameScreenAnimationsInitialized( event:Event ):void {
			_stack.getScreenById( Screens.ASSET_INITIALIZE ).removeEventListener( Event.COMPLETE, onGameScreenAnimationsInitialized );
			// Load levels
			_db.loadXml(GameSettings.ROB_PATH? "../bin/assets/levels.xml?" + GameSettings.GLOOP_VERSION : "assets/levels.xml?" + GameSettings.GLOOP_VERSION );
		}
		
		private function onDbComplete( ev:Event ):void {
			_saveStateManager.loadState(_db);
			_stack.gotoScreen(Screens.START);
			dispatchEvent( new Event( Event.COMPLETE ) ); // for the wrapper swf
		}
		
		
		private function onDbChapterSelect(ev : GameEvent) : void
		{
			_stack.gotoScreen( Screens.LEVELS );
		}
		
		
		private function onDbLevelSelect(ev : GameEvent):void {
			_stack.gotoScreen(Screens.LOADING);
			
			_db.selectedLevelProxy.addEventListener( GameEvent.LEVEL_LOAD, onSelectedLevelLoad );
			_db.selectedLevelProxy.load();
		}
		
		
		private function onDbLevelWin(ev : Event) : void
		{
			var idx : uint;
			
			_saveStateManager.saveState( _db.getStateXml() );
			
			// Unlock next level
			idx = _db.selectedLevelProxy.indexInChapter + 1;
			if (idx < _db.selectedChapter.levels.length) {
				_db.selectedChapter.levels[idx].locked = false;
			}
			
			_stack.gotoScreen(Screens.WIN);
		}
		
		
		private function onDbLevelLose(ev : Event) : void
		{
			_saveStateManager.saveState( _db.getStateXml() );
		}
		
		
		private function onSelectedLevelLoad( ev:Event ):void {
			_db.selectedLevelProxy.removeEventListener(GameEvent.LEVEL_LOAD, onSelectedLevelLoad);
			_stack.gotoScreen( Screens.GAME );
		}
		
		/**
		 * Handler for enterframe events from the stage
		 */
		private function onEnterFrame(event:Event):void
		{
			_view.render();
		}
		
		/**
		 * Handler for resize events from the stage
		 */
		private function onResize(event:Event = null):void
		{
			var w : uint, h : uint, hw : uint, hh : uint, scale : Number;
			
			_stageProperties.width = w = _stageProperties.isDesktop? stage.stageWidth : stage.fullScreenWidth;
			_stageProperties.height = h = _stageProperties.isDesktop? stage.stageHeight : stage.fullScreenHeight;
			_stageProperties.halfWidth = hw = w/2;
			_stageProperties.halfHeight = hh = h/2;
			
			//adjust the scale of buttons and text according to the resolution
			if (w < 800) {
				_stageProperties.scale = 0.5; //smaller mobile handsets
			} else if (w > 1600) {
				_stageProperties.scale = 2; //large cinema displays and ipad3
			} else {
				_stageProperties.scale = 1; // normal resolution
			}
			scale = _stageProperties.scale;
			
			//update view size
			_view.width = w;
			_view.height = h;
		}
	}
}
