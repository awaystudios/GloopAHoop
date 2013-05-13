package com.awaystudios.gloopahoop.archetypes.subtypes
{
	import com.awaystudios.gloopahoop.archetypes.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	import away3d.materials.*;
	
	/**
	 * Data class for Player projectile data
	 */
	public class PlayerBlastArchetype extends BlastArchetype
	{
		public function PlayerBlastArchetype()
		{
			id = BlastArchetype.PLAYER;
			
			material = new ColorMaterial( 0xFF0000, 0.5 );
			
			//soundOnAdd = SoundLibrary.EXPLOSION_SOFT;
		}
	}
}
