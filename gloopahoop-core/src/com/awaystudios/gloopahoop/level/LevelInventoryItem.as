package com.awaystudios.gloopahoop.level
{
	import com.awaystudios.gloopahoop.events.InventoryEvent;
	
	import flash.events.EventDispatcher;

	public class LevelInventoryItem extends EventDispatcher
	{
		private var _type : String;
		private var _variant : String;
		
		private var _numLeft : uint;
		private var _numTotal : uint;
		
		
		public function LevelInventoryItem(type : String, variant : String, numTotal : uint)
		{
			_type = type;
			_variant = variant;
			_numTotal = numTotal;
		}
		
		
		public function get type() : String
		{
			return _type;
		}
		
		
		public function get variant() : String
		{
			return _variant;
		}
		
		
		public function get numLeft() : uint
		{
			return _numLeft;
		}
		
		
		public function useOne() : void
		{
			if (_numLeft) {
				_numLeft--;
				dispatchEvent(new InventoryEvent(InventoryEvent.ITEM_CHANGE));
			}
		}
		
		
		public function reset() : void
		{
			_numLeft = _numTotal;
		}
	}
}