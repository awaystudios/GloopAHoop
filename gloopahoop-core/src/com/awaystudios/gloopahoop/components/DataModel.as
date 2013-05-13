package com.awaystudios.gloopahoop.components
{
	import com.awaystudios.gloopahoop.archetypes.*;
	
	/**
	 * @author robbateman
	 */
	public class DataModel
	{
		public var archetype : ArchetypeBase;
		public var subType : ArchetypeBase;
		
		public function DataModel( archetype : ArchetypeBase, subType : ArchetypeBase )
		{
			this.archetype = archetype;
			this.subType = subType;
		}
	}
}
