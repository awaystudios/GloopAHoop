package com.awaystudios.gloopahoop.screens.game
{
	
	import com.away3d.gloop.lib.buttons.*;
	
	import flash.display.*;
	
	public class PauseOverlay extends Sprite
	{
		private var _w : Number;
		private var _h : Number;
		
		private var _ctr : Sprite;
		
		private var _resumeBtn : ResumeButton;
		private var _mainMenuBtn : MainMenuButton;
		private var _levelSelectBtn : LevelSelectButton;
		
		public function PauseOverlay(w : Number, h : Number)
		{
			super();
			
			_w = w;
			_h = h;
			
			init();
		}
		
		
		private function init() : void
		{
			graphics.beginFill(0, 0.5);
			graphics.drawRect(0, 0, _w, _h);
			
			_ctr = new Sprite();
			_ctr.x = _w/2;
			_ctr.y = _h/2;
			_ctr.scaleX = _ctr.scaleY = _h/768;
			addChild(_ctr);
			
			_resumeBtn = new ResumeButton();
			_resumeBtn.x = -_resumeBtn.width/2;
			_resumeBtn.y = -170;
			_ctr.addChild(_resumeBtn);
			
			_mainMenuBtn = new MainMenuButton();
			_mainMenuBtn.x = -_mainMenuBtn.width/2;
			_mainMenuBtn.y = _resumeBtn.y + 140;
			_ctr.addChild(_mainMenuBtn);
			
			_levelSelectBtn = new LevelSelectButton();
			_levelSelectBtn.x = -_levelSelectBtn.width/2;
			_levelSelectBtn.y = _resumeBtn.y + 280;
			_ctr.addChild(_levelSelectBtn);
		}
		
		
		public function get resumeButton() : InteractiveObject
		{
			return _resumeBtn;
		}
		
		
		public function get mainMenuButton() : InteractiveObject
		{
			return _mainMenuBtn;
		}
		
		
		public function get levelSelectButton() : InteractiveObject
		{
			return _levelSelectBtn;
		}
	}
}