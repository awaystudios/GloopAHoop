package com.awaystudios.gloopahoop.gameobjects.components
{
	import away3d.entities.Mesh;
	import away3d.materials.lightpickers.LightPickerBase;

	public class MeshComponent
	{
		public var mesh : Mesh;
		
		public function MeshComponent()
		{
		}
		
		
		public function setLightPicker(picker : LightPickerBase) : void
		{
			if (mesh && mesh.material)
				mesh.material.lightPicker = picker;
		}
	}
}