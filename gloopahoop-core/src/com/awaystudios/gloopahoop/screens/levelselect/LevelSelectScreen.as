package com.awaystudios.gloopahoop.screens.levelselect
{

	
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.level.*;
	import com.awaystudios.gloopahoop.screens.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	import flash.events.*;

	public class LevelSelectScreen extends ScreenBase
	{
		private var _db : LevelDatabase;
		private var _stack : ScreenStack;
		
		private var _totalStars : StarTotal;
		private var _thumbs : Vector.<LevelThumb>;
		
		public function LevelSelectScreen(db : LevelDatabase, stack : ScreenStack)
		{
			super(true, true);
			
			_db = db;
			_stack = stack;
		}
		
		
		protected override function initScreen() : void
		{
			var i : uint;
			var len : uint;
			
			_thumbs = new Vector.<LevelThumb>();
			
			_totalStars = new StarTotal(_db);
			_totalStars.x = _w - 140 * _masterScaleY;
			_totalStars.y = 24 * _masterScaleY;
			_totalStars.scaleX = _masterScaleY;
			_totalStars.scaleY = _masterScaleY;
			addChild(_totalStars);
			
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
		}
		
		
		public override function activate() : void
		{
			var i : uint;
			var len : uint;
			var cols : uint;
			var rows : uint;
			var tlx : Number;
			var tly : Number;
			
			super.activate();
				
			len = _thumbs.length;
			
			for (i=0; i<len; i++)
				if (_thumbs[i].parent == this)
					removeChild(_thumbs[i]);
			
			len = _db.selectedChapter.levels.length;
			
			if( len < 9 ) {
				cols = 4;
			}
			else if( len < 16 ) {
				cols = 5;
			}
			else if( len < 25 ) {
				cols = 6;
			}
			else {
				cols = 7;
			}
			
			rows = Math.ceil(len / cols);
			
			tlx = _w/2 - cols * 70 * _masterScale;
			tly = _h/2 - rows * 75 * _masterScale + 40 * _masterScaleY;
			
			var lastIsCompleted:Boolean;
			for (i=0; i<len; i++) {
				var thumb : LevelThumb;
				var level : LevelProxy;
				var row : uint;
				var col : uint;
				
				row = Math.floor(i / cols);
				col = i % cols;
				
				level = _db.selectedChapter.levels[i];
				
				if( level.completed ) {
					level.locked = false;
					lastIsCompleted = true;
				}
				else {
					if( lastIsCompleted ) {
						level.locked = false;
					}
					lastIsCompleted = false;
				}

				if (_thumbs.length == i) {
					_thumbs.push(thumb = new LevelThumb(level));
					thumb.addEventListener(MouseEvent.CLICK, onThumbClick);
				} else {
					thumb = _thumbs[i];
					thumb.levelProxy = level;
				}
				
				thumb.x = tlx + col * 140 * _masterScale;
				thumb.y = tly + row * 150 * _masterScale;
				thumb.scaleX = _masterScaleX;
				thumb.scaleY = _masterScaleX;
				
				addChild(thumb);
			}
			
			len = _thumbs.length;
			for (i=0; i<len; i++) {
				_thumbs[i].redraw();
			}
			
			_totalStars.redraw();
		}
		
		
		private function onThumbClick(ev : MouseEvent) : void
		{
			var thumb : LevelThumb;
			
			thumb = LevelThumb(ev.currentTarget);
			
			// Don't allow selection of locked levels
			if( !GameSettings.DEV_MODE ) {
				if( thumb.levelProxy.locked )
					return;
			}
			
			SoundManager.play(Sounds.MENU_BUTTON);
			_db.selectLevel(thumb.levelProxy);
		}
		
		
		private function onBackBtnClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stack.gotoScreen(Screens.CHAPTERS);
		}
	}
}