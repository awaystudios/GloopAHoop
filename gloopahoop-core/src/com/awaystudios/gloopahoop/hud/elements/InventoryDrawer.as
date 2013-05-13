package com.awaystudios.gloopahoop.hud.elements
{
	import com.awaystudios.gloopahoop.level.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.*;
	
	public class InventoryDrawer extends Sprite
	{
		private var _w : Number;
		private var _h : Number;
		private var _ctr : Sprite;
		private var _bg : Shape;
		
		private var _items : Vector.<InventoryItemButton>;
		private var _selectedItem : LevelInventoryItem;
		
		private var _tabHit : Sprite;
		
		private var _open : Boolean;
		
		
		public function InventoryDrawer(h : Number)
		{
			super();
			
			_w = 140;
			_h = h;
			
			init();
		}
		
		
		private function init() : void
		{
			var cr : Number;
			var tw : Number;
			var th : Number;
			
			_w = 140;
			cr = 20; // Curve radius
			tw = 15; // Tab width, excluding curve
			th = 30; // Tab height, excluding curve
			
			_ctr = new Sprite();
			_ctr.x = -_w;
			addChild(_ctr);
			
			_bg = new Shape();
			_bg.alpha = 0.5;
			_bg.cacheAsBitmap = true;
			_ctr.addChild(_bg);
			
			_tabHit = new Sprite();
			_tabHit.graphics.beginFill(0xffcc00, 0);
			_tabHit.graphics.drawRect(0, 0, tw+cr, cr+th+cr);
			_tabHit.x = _w;
			_tabHit.addEventListener(MouseEvent.CLICK, onTabClick);
			_ctr.addChild(_tabHit);
			
			//_bg.graphics.lineStyle(5, 0xcccccc, 1);
			_bg.graphics.beginFill(0);
			_bg.graphics.lineTo(_w+tw, 0);
			_bg.graphics.curveTo(_w+tw+cr, 0, _w+tw+cr, cr);
			_bg.graphics.lineTo(_w+tw+cr, cr+th);
			_bg.graphics.curveTo(_w+tw+cr, cr+th+cr, _w+tw, cr+th+cr);
			_bg.graphics.lineTo(_w, cr+th+cr);
			_bg.graphics.lineTo(_w, _h-cr);
			_bg.graphics.curveTo(_w, _h, _w-cr, _h);
			_bg.graphics.lineTo(0, _h);
			_bg.graphics.endFill();
			
			_items = new Vector.<InventoryItemButton>();
		}
		
		
		public function get selectedItem() : LevelInventoryItem
		{
			return _selectedItem;
		}
		
		
		public function clear() : void
		{
			var btn : InventoryItemButton;
			
			while (btn = _items.pop()) {
				btn.removeEventListener(MouseEvent.CLICK, onInventoryButtonClick);
				removeChild(btn);
			}
		}
		
		
		public function addItem(item : LevelInventoryItem) : void
		{
			var btn : InventoryItemButton;
			
			btn = new InventoryItemButton(item);
			btn.scaleX = 0.5;
			btn.scaleY = 0.5;
			btn.x = _w/2;
			btn.y = _items.length*100 + 60;
			btn.mouseEnabled = true;
			btn.addEventListener(MouseEvent.CLICK, onInventoryButtonClick);
				
			_ctr.addChild(btn);
			_items.push(btn);
		}
		
		
		private function onInventoryButtonClick(ev : MouseEvent) : void
		{
			var btn : InventoryItemButton;
			
			btn = InventoryItemButton(ev.currentTarget);
			_selectedItem = btn.inventoryItem;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		
		private function onTabClick(ev : MouseEvent) : void
		{
			var posx : Number;
			
			_open = !_open;
			posx = _open? 0 : -_w;
			
			TweenLite.to(_ctr, 0.2, { x: posx, ease: Cubic.easeInOut });
		}
	}
}