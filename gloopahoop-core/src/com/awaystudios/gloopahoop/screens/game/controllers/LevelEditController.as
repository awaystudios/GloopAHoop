package com.awaystudios.gloopahoop.screens.game.controllers
{
	import com.awaystudios.gloopahoop.events.*;
	import com.awaystudios.gloopahoop.gameobjects.*;
	import com.awaystudios.gloopahoop.gameobjects.hoops.*;
	import com.awaystudios.gloopahoop.level.*;

	public class LevelEditController
	{
		private var _levelProxy : LevelProxy;
		
		public function LevelEditController()
		{
		}
		
		
		
		public function activate(levelProxy : LevelProxy) : void
		{
			_levelProxy = levelProxy;
			_levelProxy.inventory.addEventListener(InventoryEvent.ITEM_SELECT, onInventorySelect);
		}
		
		
		public function deactivate() : void
		{
			_levelProxy.removeEventListener(InventoryEvent.ITEM_SELECT, onInventorySelect);
		}
		
		
		
		private function onInventorySelect(ev : InventoryEvent) : void
		{
			var item : LevelInventoryItem;
			
			item = ev.item;
			
			if (item.type == GameObjectType.HOOP) {
				var hoop : Hoop;
				
				switch (item.variant) {
					case HoopType.TRAMPOLINE:
						hoop = new TrampolineHoop();
						break;
					case HoopType.ROCKET:
						hoop = new RocketHoop();
						break;
				}
				
				if (hoop) {
					item.useOne();
					_levelProxy.level.queueHoopForPlacement(hoop);
				}
			}
		}
	}
}