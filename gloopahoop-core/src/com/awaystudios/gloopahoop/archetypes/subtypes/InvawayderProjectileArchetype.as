package com.awaystudios.gloopahoop.archetypes.subtypes
{
	import com.awaystudios.gloopahoop.archetypes.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	/**
	 * Data class for Invawayder projectile data
	 */
	public class InvawayderProjectileArchetype extends ProjectileArchetype
	{
		public function InvawayderProjectileArchetype()
		{
			id = ProjectileArchetype.INVAWAYDER;
			
			//soundOnAdd = SoundLibrary.INVAWAYDER_FIRE;
		}
	}
}
