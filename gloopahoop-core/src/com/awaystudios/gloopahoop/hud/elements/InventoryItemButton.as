package com.awaystudios.gloopahoop.hud.elements
{
	import com.awaystudios.gloopahoop.events.*;
	import com.awaystudios.gloopahoop.gameobjects.hoops.*;
	import com.awaystudios.gloopahoop.level.*;
	import com.away3d.gloop.lib.hoops.*;
	
	import flash.display.*;
	import flash.geom.*;

	public class InventoryItemButton extends Sprite
	{
		private var _item : LevelInventoryItem;
		
		public function InventoryItemButton(item : LevelInventoryItem)
		{
			super();
			
			_item = item;
			
			init();
		}
		
		private  function init() : void
		{
			var mtx : Matrix;
			var bmp : BitmapData;
			
			switch (_item.variant) {
				case HoopType.ROCKET:
					bmp = new RocketHoopBitmap();
					break;
				case HoopType.TRAMPOLINE:
					bmp = new SpringHoopBitmap();
					break;
			}
			
			mtx = new Matrix(1, 0, 0, 1, -bmp.width/2, -bmp.height/2);
			graphics.beginBitmapFill(bmp, mtx, false, true);
			graphics.drawRect(-bmp.width/2, -bmp.height/2, bmp.width, bmp.height);
			
			_item.addEventListener(InventoryEvent.ITEM_CHANGE, onItemChange);
		}
		
		
		public function get inventoryItem() : LevelInventoryItem
		{
			return _item;
		}
		
		
		private function onItemChange(ev : InventoryEvent) : void
		{
			// TODO: visual cue
		}
	}
}