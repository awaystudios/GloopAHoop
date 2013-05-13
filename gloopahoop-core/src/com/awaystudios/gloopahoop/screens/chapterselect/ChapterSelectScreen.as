package com.awaystudios.gloopahoop.screens.chapterselect
{
	
	import com.awaystudios.gloopahoop.level.*;
	import com.awaystudios.gloopahoop.screens.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	import flash.display.*;
	import flash.events.*;
	
	public class ChapterSelectScreen extends ScreenBase
	{
		private var _db : LevelDatabase;
		private var _stack : ScreenStack;
		private var _posters : Vector.<ChapterPoster>;
		
		private var _prevPoster : ChapterPoster;
		private var _curPoster : ChapterPoster;
		private var _nextPoster : ChapterPoster;
		
		private var _curPosterIdx : uint;
		
		private var _dragging : Boolean;
		private var _targetX : Number;
		private var _centerX : Number;
		private var _mouseDownX : Number;
		
		
		public function ChapterSelectScreen(db : LevelDatabase, stack : ScreenStack)
		{
			super(true, true);
			
			_db = db;
			_stack = stack;
		}
		
		
		protected override function initScreen():void
		{
			var i : uint;
			var len : uint;
			
			_centerX = _w/2;
			_targetX = _centerX;
			
			_posters = new Vector.<ChapterPoster>();
			
			len = _db.chapters.length;
			for (i=0; i<len; i++) {
				var chapter : ChapterData;
				var poster : ChapterPoster;
				
				chapter = _db.chapters[i];
				poster = new ChapterPoster(_w, _h, chapter);
				poster.x = _centerX + _w * i/2;
				poster.y = _h/2;
				poster.addEventListener(MouseEvent.CLICK, onPosterClick);
				addChild(poster);
				
				_posters.push(poster);
			}
			
			_curPosterIdx = 0;
			
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
		}
		
		
		public override function activate() : void
		{
			super.activate();
			updatePosters();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			
			stage.quality = StageQuality.LOW;
		}
		
		
		public override function deactivate() : void
		{
			super.deactivate();
			endDrag();
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			
			stage.quality = StageQuality.HIGH;
		}
		
		
		private function updatePosters() : void
		{
			_prevPoster = (_curPosterIdx>0)? _posters[_curPosterIdx-1] : null;
			_curPoster = _posters[_curPosterIdx];
			_nextPoster = (_curPosterIdx<_posters.length-1)? _posters[_curPosterIdx+1] : null;
		}
		
		private function endDrag() : void
		{
			_dragging = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		
		private function onStageMouseDown(ev : MouseEvent) : void
		{
			_dragging = true;
			_mouseDownX = stage.mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		
		private function onStageMouseMove(ev : MouseEvent) : void
		{
		}
		
		
		private function onStageMouseUp(ev : MouseEvent) : void
		{
			endDrag();
			
			if (_targetX - _w/2 < -0.25*_w && _curPosterIdx < _posters.length-1) {
				_curPosterIdx++;
			}
			else if (_targetX - _w/2 > 0.25*_w && _curPosterIdx > 0) {
				_curPosterIdx--;
			}
			
			updatePosters();
			
			_targetX = _centerX;
		}
		
		
		private function onPosterClick(ev : MouseEvent) : void
		{
			var dx : Number;
			
			dx = ev.stageX - _mouseDownX;
			if (dx < 10 && dx > -10) {
				var poster : ChapterPoster = ChapterPoster(ev.currentTarget);
				
				//if (poster.chapterData.idx)
				//	return;
				
				SoundManager.play(Sounds.MENU_BUTTON);
				
				_db.selectChapter(poster.chapterData);
			}
		}
		
		
		private function onBackBtnClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stack.gotoScreen(Screens.START);
		}
		
		
		override protected function update():void
		{
			if (_dragging) {
				var dx : Number;
				var mul : Number;
				
				dx = (stage.mouseX - _mouseDownX);
				
				mul = 1;
				if (dx < 0 && _curPosterIdx == _posters.length-1)
					mul = 0.5;
				else if (dx > 0 && _curPosterIdx == 0)
					mul = 0.5;
				
				_targetX = _centerX + dx * mul;
			}
			
			_curPoster.x += (_targetX - _curPoster.x) * 0.2;
			
			if (_prevPoster)
				_prevPoster.x = _curPoster.x - _w/2;
			if (_nextPoster)
				_nextPoster.x = _curPoster.x + _w/2;
		}
	}
}