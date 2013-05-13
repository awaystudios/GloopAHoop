package com.awaystudios.gloopahoop.archetypes.subtypes
{
	import com.awaystudios.gloopahoop.archetypes.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	import away3d.materials.*;
	
	/**
	 * Data class for Player projectile data
	 */
	public class InvawayderBlastArchetype extends BlastArchetype
	{
		public function InvawayderBlastArchetype()
		{
			id = BlastArchetype.INVAWAYDER;
			
			material = new ColorMaterial( 0x00FFFF, 0.5 );
			
			//soundOnAdd = SoundLibrary.BOING;
		}
	}
}
