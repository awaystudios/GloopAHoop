package com.awaystudios.gloopahoop.hud.elements
{
	import com.away3d.gloop.lib.hud.*;
	
	import away3d.materials.*;
	
	import flash.display.*;

	public class StarIcon extends Sprite
	{
		private var _ui : StarIconUI;
		
		private var _collected : Boolean;
		
		public function StarIcon()
		{
			super();
			
			init();
			redraw();
		}
		
		
		private function init() : void
		{
			_ui = new StarIconUI();
			addChild(_ui);
		}
		
		
		public function get collected() : Boolean
		{
			return _collected;
		}
		public function set collected(val : Boolean) : void
		{
			_collected = val;
			redraw();
		}
		
		
		private function redraw() : void
		{
			_ui.blob.visible = _collected;
		}
	}
}