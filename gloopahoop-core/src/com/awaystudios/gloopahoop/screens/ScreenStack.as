package com.awaystudios.gloopahoop.screens
{
	
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	import flash.display.*;

	public class ScreenStack
	{
		private var _w : Number;
		private var _h : Number;
		private var _ctr : Sprite;
		
		private var _screens : Vector.<ScreenBase>;
		private var _screens_by_id : Object;
		private var _active_screen : ScreenBase;
		
		public function ScreenStack(stageProperties:StageProperties, ctr : Sprite)
		{
			_w = stageProperties.width;
			_h = stageProperties.height;
			_ctr = ctr;
			
			_screens = new Vector.<ScreenBase>();
			_screens_by_id = {};
		}
		
		
		public function addScreen(id : String, screen : ScreenBase) : void
		{
			_screens_by_id[id] = screen;
			_screens.push(screen);
		}
		
		
		public function gotoScreen(id : String) : void
		{
			if (_active_screen) {
				_active_screen.deactivate();
				_ctr.removeChild(_active_screen);
				_active_screen = null;
			}
			
			_active_screen = _screens_by_id[id];
			_ctr.addChild(_active_screen);
			_active_screen.init(_w, _h);
			
			if (_active_screen.musicTheme)
				MusicManager.play(_active_screen.musicTheme);
			
			_active_screen.activate();
		}

		public function getScreenById( id:String ):ScreenBase {
			return _screens_by_id[ id ];
		}
	}
}