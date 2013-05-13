package com.awaystudios.gloopahoop.screens.settings
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ToggleButton extends Sprite
	{
		private var _bmp : Bitmap;
		private var _onBmp : BitmapData;
		private var _offBmp : BitmapData;
		
		private var _toggled : Boolean;
		
		public function ToggleButton(onState : BitmapData, offState : BitmapData)
		{
			super();
			
			_onBmp = onState;
			_offBmp = offState;
			
			_bmp = new Bitmap(_offBmp);
			_bmp.x = -(_bmp.width/2);
			_bmp.y = -(_bmp.height/2);
			addChild(_bmp);
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		
		public function get toggledOn() : Boolean
		{
			return _toggled;
		}
		public function set toggledOn(val : Boolean) : void
		{
			_toggled = val;
			redraw();
		}
		
		
		private function onClick(ev : MouseEvent) : void
		{
			_toggled = !_toggled;
			redraw();
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		private function redraw() : void
		{
			_bmp.bitmapData = _toggled? _onBmp : _offBmp;
			_bmp.smoothing = true;
		}
	}
}