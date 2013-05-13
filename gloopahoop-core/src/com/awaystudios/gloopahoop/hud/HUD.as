package com.awaystudios.gloopahoop.hud
{
	import com.awaystudios.gloopahoop.events.*;
	import com.awaystudios.gloopahoop.hud.elements.*;
	import com.awaystudios.gloopahoop.level.*;
	import com.away3d.gloop.lib.*;
	import com.away3d.gloop.lib.hud.*;
	
	import flash.display.*;
	import flash.events.*;

	public class HUD extends Sprite
	{
		private var _w : Number;
		private var _h : Number;
		
		private var _levelProxy : LevelProxy;
		
		private var _stars : Vector.<StarIcon>;
		
		private var _levelTitles:LevelTitles;
		
		private var _helpText:HelpText;
		
		//private var _inventory : InventoryDrawer;
		
		private var _restartBtn : RestartButton;
		private var _pauseBtn : PauseButton;
		
		public function get levelTitles():LevelTitles
		{
			return _levelTitles;
		}
		
		public function get helpText():HelpText
		{
			return _helpText;
		}
		
		public function HUD(w : Number, h : Number)
		{
			_w = w;
			_h = h;
			mouseEnabled = false;
			init();
		}
		
		
		private function init() : void
		{
			_stars = new Vector.<StarIcon>();
			_stars[0] = new StarIcon();
			_stars[0].x = 30;
			_stars[0].y = 50;
			addChild(_stars[0]);
			
			_stars[1] = new StarIcon();
			_stars[1].x = 90;
			_stars[1].y = _stars[0].y;
			addChild(_stars[1]);
			
			_stars[2] = new StarIcon();
			_stars[2].x = 150;
			_stars[2].y = _stars[0].y;
			addChild(_stars[2]);
			
			/*
			_inventory = new InventoryDrawer(_h - 200);
			_inventory.y = 100;
			_inventory.addEventListener(Event.SELECT, onInventorySelect);
			addChild(_inventory);
			*/
			
			_restartBtn = new RestartButton();
			_restartBtn.x = _w - 120;
			_restartBtn.y = 50;
			_restartBtn.addEventListener(MouseEvent.CLICK, onRestartBtnClick);
			addChild(_restartBtn);
			
			_pauseBtn = new PauseButton();
			_pauseBtn.x = _w - 50;
			_pauseBtn.y = _restartBtn.y;
			_pauseBtn.addEventListener(MouseEvent.CLICK, onPauseBtnClick);
			addChild(_pauseBtn);
			
			_levelTitles = new LevelTitles();
			_levelTitles.visible = false;
			_levelTitles.x = _w/2;
			_levelTitles.y = _h/2;
			_levelTitles.mouseEnabled = false;
			_levelTitles.mouseChildren = false;
			addChild(_levelTitles);
			
			_helpText = new HelpText();
			_helpText.visible = false;
			_helpText.helpTextButton.addEventListener(MouseEvent.CLICK, onHelpTextBtnClick);
			_helpText.x = _w/2;
			_helpText.y = _h/2 + 25;
			_helpText.scaleX = _helpText.scaleY = _w/1024;
			addChild(_helpText);
		}
		
		
		public function reset(levelProxy : LevelProxy) : void
		{
			if (levelProxy != _levelProxy) {
				if (_levelProxy) {
					_levelProxy.removeEventListener(GameEvent.LEVEL_STAR_COLLECT, onLevelProxyStarCollect);
				}
				
				_levelProxy = levelProxy;
				_levelProxy.addEventListener(GameEvent.LEVEL_STAR_COLLECT, onLevelProxyStarCollect);
				
				clear();
				draw();
			}
			
			_stars[0].collected = false;
			_stars[1].collected = false;
			_stars[2].collected = false;
		}
		
		
		private function draw() : void
		{
			/*
			var i : uint;
			var len : uint;
			
			len = _levelProxy.inventory.items.length;
			for (i=0; i<len; i++) {
				var item : LevelInventoryItem;
				
				item = _levelProxy.inventory.items[i];
				_inventory.addItem(item);
			}
			*/
		}
		
		
		private function clear() : void
		{
			//_inventory.clear();
		}
		
		
		private function onLevelProxyStarCollect(ev : GameEvent) : void
		{
			var i : uint;
			var len : uint;
			
			len = _levelProxy.starsCollected;
			
			for (i=0; i<len; i++) {
				_stars[i].collected = true;
			}
		}
			
		/*
		private function onInventorySelect(ev : Event) : void
		{
			_levelProxy.inventory.select(_inventory.selectedItem);
		}
		*/
		
		
		private function onPauseBtnClick(ev : MouseEvent) : void
		{
			_levelProxy.pause();
		}
		
		private function onHelpTextBtnClick(ev : MouseEvent) : void
		{
			_helpText.visible = false;
		}
		
		private function onRestartBtnClick(ev : MouseEvent) : void
		{
			_levelProxy.reset();
		}
	}
}