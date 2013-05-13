package com.awaystudios.gloopahoop.gameobjects
{

	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.components.*;
	
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	
	import flash.geom.*;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Wall extends DefaultGameObject {
		
		public function Wall(offsetX:Number, offsetY:Number, width:Number, height:Number, worldX:Number = 0, worldY:Number = 0) {
			super();
			
			if(!_physics) _physics = new WallPhysicsComponent(this, offsetX, offsetY, width, height);
			_physics.x = worldX;
			_physics.y = worldY;

			if (GameSettings.SHOW_COLLISION_WALLS){
				var material:ColorMaterial = new ColorMaterial(debugColor1);
				_meshComponent = new MeshComponent();
				var cube:CubeGeometry = new CubeGeometry(width, height, 60);
				var mtx:Matrix3D = new Matrix3D;
				mtx.appendTranslation(width/2, -height/2, 0);
				mtx.appendTranslation(offsetX, offsetY, 0);
				_meshComponent.mesh = new Mesh(cube, material);
				cube.applyTransformation(mtx);
			}
		}

		override public function get debugColor1():uint {
			return 0x642BA4;
		}
		
	}

}