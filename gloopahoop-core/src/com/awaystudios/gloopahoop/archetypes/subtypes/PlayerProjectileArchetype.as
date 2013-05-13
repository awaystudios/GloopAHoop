package com.awaystudios.gloopahoop.archetypes.subtypes
{
	import com.awaystudios.gloopahoop.archetypes.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	import away3d.materials.*;
	
	/**
	 * Data class for Player projectile data
	 */
	public class PlayerProjectileArchetype extends ProjectileArchetype
	{
		public function PlayerProjectileArchetype()
		{
			id = ProjectileArchetype.PLAYER;
			
			material = new ColorMaterial( 0x00FFFF, 0.75 );
			
			//soundOnAdd = SoundLibrary.PLAYER_FIRE;
		}
	}
}