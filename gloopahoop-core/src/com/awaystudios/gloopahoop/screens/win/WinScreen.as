package com.awaystudios.gloopahoop.screens.win
{
	
	import com.awaystudios.gloopahoop.level.*;
	import com.away3d.gloop.lib.*;
	import com.awaystudios.gloopahoop.screens.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	import flash.events.*;
	import flash.geom.*;
	
	public class WinScreen extends ScreenBase
	{
		private var _ui : WinScreenUI;
		
		private var _db : LevelDatabase;
		private var _stack : ScreenStack;
		
		private var _dimCtf : ColorTransform;
		private var _normalCtf : ColorTransform;

		private var _onFinalWin:Boolean;
		
		public function WinScreen(db : LevelDatabase, stack : ScreenStack)
		{
			super();
			
			_db = db;
			_stack = stack;
			
			_musicTheme = null;
		}
		
		
		protected override function initScreen():void
		{
			_ui = new WinScreenUI();
			_ui.y = -100;
			_ctr.addChild(_ui);
			
			_ui.replayButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			_ui.menuButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			_ui.nextButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			_dimCtf = new ColorTransform(0, 0, 0, 1, 0x48, 0x1e, 0x3c);
			_normalCtf = new ColorTransform;
		}
		
		
		public override function activate() : void
		{
			var proxy : LevelProxy;
			var nextIdx : uint;
			
			
			proxy = _db.selectedLevelProxy;
			
			_ui.scoreTextfield.text = proxy.calcRoundScore().toString();
			_ui.blob0.transform.colorTransform = (proxy.starsCollected > 0) ? _normalCtf : _dimCtf;
			_ui.blob1.transform.colorTransform = (proxy.starsCollected > 1) ? _normalCtf : _dimCtf;
			_ui.blob2.transform.colorTransform = (_db.selectedLevelProxy.starsCollected > 2) ? _normalCtf : _dimCtf;
			
			nextIdx = _db.selectedLevelProxy.indexInChapter + 1;
			_ui.nextButton.visible = (nextIdx < _db.selectedChapter.levels.length);

			// end screen on next btn click?
//			if( _db.isSelectedChapterTheLastOne() ) { // are we on the last chapter?
				var idx:uint = _db.selectedLevelProxy.indexInChapter + 1;
				if( idx >= _db.selectedChapter.levels.length ) { // is there not another level
					_ui.nextButton.visible = true;
					_onFinalWin = true;
				}
//			}
		}
		
		
		private function onButtonClick(ev : MouseEvent) : void
		{
			var nextIdx : uint;
			
			SoundManager.play(Sounds.MENU_BUTTON);
			
			switch (ev.currentTarget) {
				case _ui.replayButton:
					_stack.gotoScreen(Screens.GAME);
					break;
				case _ui.menuButton:
					_stack.gotoScreen(Screens.START);
					break;
				case _ui.nextButton:

					if( _onFinalWin ) {
						_stack.gotoScreen(Screens.GAME_WIN);
						_onFinalWin = false;
					}
					else {
						nextIdx = _db.selectedLevelProxy.indexInChapter + 1;
						_db.selectLevel(_db.selectedChapter.levels[nextIdx]);
					}

					break;
			}
		}
	}
}