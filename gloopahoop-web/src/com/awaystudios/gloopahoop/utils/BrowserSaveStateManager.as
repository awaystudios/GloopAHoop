package com.awaystudios.gloopahoop.utils
{
	import com.awaystudios.gloopahoop.level.*;
	
	import flash.net.*;
	
	/**
	 * Saves and loads the state of the game.
	 */
	public class BrowserSaveStateManager extends SaveStateManager
	{
		private const GLOOP_SO_NAME:String = "gloopahoopUserData";
		
		/**
		 * @inheritDoc
		 */		
		override public function saveState( xml:XML ):void {
			var sharedObject:SharedObject = SharedObject.getLocal( GLOOP_SO_NAME );
			sharedObject.data.state = xml.copy();
			sharedObject.flush();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function loadState( db:LevelDatabase ):void
		{
			var sharedObject:SharedObject = SharedObject.getLocal( GLOOP_SO_NAME );
			var state:XML = sharedObject.data.state;
			if( state ) {
				db.setStateFromXml( state );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clearState():void {
			var sharedObject:SharedObject = SharedObject.getLocal( GLOOP_SO_NAME );
			sharedObject.clear();
		}
	}
}