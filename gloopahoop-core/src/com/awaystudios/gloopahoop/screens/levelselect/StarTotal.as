package com.awaystudios.gloopahoop.screens.levelselect
{
	
	import com.awaystudios.gloopahoop.level.*;
	import com.away3d.gloop.lib.*;
	
	import flash.display.*;
	import flash.text.*;
	
	public class StarTotal extends Sprite
	{
		private var _db : LevelDatabase;
		
		private var _ui : StarTotalUI;
		
		public function StarTotal(db : LevelDatabase)
		{
			super();
			
			_db = db;
			
			init();
		}
		
		
		private function init() : void
		{
			_ui = new StarTotalUI();
			_ui.labelTextfield.autoSize = TextFieldAutoSize.LEFT;
			_ui.labelTextfield.text = '';
			addChild(_ui);
		}
		
		
		public function redraw() : void
		{
			if (_db.selectedChapter) {
				var stars : uint;
				
				stars = _db.selectedChapter.calcTotalStarsCollected();
				_ui.labelTextfield.text = stars.toString();
			}
		}
	}
}