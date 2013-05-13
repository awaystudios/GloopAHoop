package com.awaystudios.gloopahoop.screens.levelselect
{
	
	import com.awaystudios.gloopahoop.level.*;
	import com.away3d.gloop.lib.*;
	
	import flash.display.*;
	
	public class LevelThumb extends Sprite
	{
		private var _ui : LevelThumbUI;
		private var _proxy : LevelProxy;
		
		public function LevelThumb(proxy : LevelProxy)
		{
			super();
			
			_ui = new LevelThumbUI();
			addChild(_ui);
			
			levelProxy = proxy;
		}
		
		
		private function init() : void
		{
			_ui = new LevelThumbUI();
			addChild(_ui);
		}
		
		
		public function get levelProxy() : LevelProxy
		{
			return _proxy;
		}
		
		public function set levelProxy( val : LevelProxy ) : void
		{
			_proxy = val;
			_ui.indexTextfield.text = (_proxy.indexInChapter+1).toString();
		}
		
		
		public function redraw() : void
		{
			_ui.blob0.visible = (_proxy.bestStarsCollected > 0);
			_ui.blob1.visible = (_proxy.bestStarsCollected > 1);
			_ui.blob2.visible = (_proxy.bestStarsCollected > 2);
			_ui.padlock.visible = _proxy.locked;
			if( _proxy.completed ) _ui.padlock.visible = false;
		}
	}
}