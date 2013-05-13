package com.awaystudios.gloopahoop.events
{
	import com.awaystudios.gloopahoop.level.*;
	
	import flash.events.*;
	
	public class InventoryEvent extends Event
	{
		private var _item : LevelInventoryItem;
		
		public static const ITEM_SELECT : String = 'itemSelect';
		public static const ITEM_CHANGE : String = 'itemReturn';
		
		public function InventoryEvent(type:String, item : LevelInventoryItem = null)
		{
			super(type);
			
			_item = item;
		}
		
		
		public function get item() : LevelInventoryItem
		{
			return _item;
		}
		
		
		public override function clone() : Event
		{
			return new InventoryEvent(type, item);
		}
	}
}