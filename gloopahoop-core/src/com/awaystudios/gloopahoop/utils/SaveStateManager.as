package com.awaystudios.gloopahoop.utils
{
	import com.awaystudios.gloopahoop.level.*;
	
	import away3d.errors.*;
	
	/**
	 * Saves and loads the high score value of the game.
	 */
	public class SaveStateManager
	{
		/**
		 * Saves the game state to a local shared object.
		 * 
		 * @param highScore The game state to be saved.
		 */
		public function saveState( xml:XML ):void
		{
			throw new AbstractMethodError();
		}
		
		/**
		 * Loads the game state from an existing shared object.
		 * 
		 * @return The last known game state saved.
		 */
		public function loadState( db:LevelDatabase ):void
		{
			throw new AbstractMethodError();
		}
		
		public function clearState():void {
			throw new AbstractMethodError();
		}
	}
}
