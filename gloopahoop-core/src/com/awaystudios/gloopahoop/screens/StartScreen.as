package com.awaystudios.gloopahoop.screens
{
	
	import com.away3d.gloop.lib.*;
	import com.away3d.gloop.lib.buttons.PlayButton;
	import com.away3d.gloop.lib.buttons.SettingsButton;
	import com.awaystudios.gloopahoop.sounds.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class StartScreen extends ScreenBase
	{
		private var _stack : ScreenStack;
		
		private var _logo : Sprite;
		private var _playBtn : SimpleButton;
		private var _settingsBtn : SimpleButton;
		
		public function StartScreen(stack : ScreenStack)
		{
			super();
			_stack = stack;
		}

		protected override function initScreen():void
		{
			var logoBitmap:Bitmap = new Bitmap(new LogoBitmap(), "auto", true);
			var logoBmp:Bitmap;
			
			//if (_masterScaleY > 1) {
			//	logoBmp = logoBitmap;
			//	logoBmp.scaleX = _masterScaleY;
			//	logoBmp.scaleY = _masterScaleY;
			//} else {
				logoBmp = new Bitmap(new BitmapData(logoBitmap.width*_masterScaleY, logoBitmap.height*_masterScaleY, true, 0x0), "auto", true);
				logoBmp.bitmapData.draw(logoBitmap, new Matrix(_masterScaleY, 0, 0, _masterScaleY));
			//}
			
			logoBmp.x = -(logoBmp.width/2);
			logoBmp.y = -(logoBmp.height/2);
			
			_logo = new Sprite();
			_logo.x = _w/2;
			_logo.addChild(logoBmp);
			addChild(_logo);
			
			_playBtn = new PlayButton();
			_playBtn.x = - _playBtn.width/2;
			_playBtn.y = -0.1 * _h;
			_playBtn.addEventListener(MouseEvent.CLICK, onPlayBtnClick);
			_ctr.addChild(_playBtn);
			
			_settingsBtn = new SettingsButton();
			_settingsBtn.x = - _settingsBtn.width/2;
			_settingsBtn.y = _playBtn.y + 140;
			_settingsBtn.addEventListener(MouseEvent.CLICK, onSettingsBtnClick);
			_ctr.addChild(_settingsBtn);
		}
		
		public override function activate():void
		{
			super.activate();
			
			// Call update before being added to stage
			// to prevent logo from jumping on first frame
			update();
		}
		
		override protected function update():void {
			var t:Number = getTimer();
			_logo.rotation = Math.sin(t / 300) * 1.5;
			_logo.scaleX = 1.0 + Math.cos(t / 150) * .025;
			_logo.y = _h/2-(200 + Math.cos(t / 300) * 7)*_masterScaleY;
		}
		
		private function onSettingsBtnClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stack.gotoScreen(Screens.SETTINGS);
		}
		
		
		private function onPlayBtnClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stack.gotoScreen(Screens.CHAPTERS);
		}
		
		
	}
}