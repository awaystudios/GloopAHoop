package com.awaystudios.gloopahoop.gameobjects
{

	import Box2DAS.Dynamics.*;
	
	import away3d.core.base.*;
	import away3d.entities.*;
	import away3d.library.*;
	import away3d.materials.*;
	import away3d.textures.*;
	
	import com.awaystudios.gloopahoop.gameobjects.components.*;
	import com.awaystudios.gloopahoop.sounds.*;
	import com.awaystudios.gloopahoop.utils.*;
	
	import flash.display.*;

	public class Monitor extends DefaultGameObject
	{
		private var _initialX:Number;
		private var _initialY:Number;
		private var _initialZ:Number;
		private var _initialRotation:Number;
		private var _type:String;
		
		public function Monitor( worldX:Number = 0, worldY:Number = 0, worldZ:Number = 0, rotation:Number = 0, type:String = "small" ) {

			super();
			_initialX = worldX;
			_initialY = worldY;
			_initialZ = worldZ;
			_initialRotation = rotation;
/*
			_physics = new MonitorPhysicsComponent( this );
			_physics.x = _initialX = worldX;
			_physics.y = _initialY = worldY;
			_physics.applyGravity = true;
			_physics.restitution = 0.5;
			_physics.friction = 0.8;
			_physics.inertiaScale = 2;
			_physics.enableReportBeginContact();
			_physics.density = Settings.BOX_DENSITY;
*/
			_type = type;
			
			initVisual();
		}

		override public function onCollidingWithSomethingStart( event:ContactEvent ):void {

			var speed:Number = _physics.b2body.GetLinearVelocity().length();
			if( speed > 1 ) {
				SoundManager.play( Sounds.GAME_BOING );
			}

		}

		private function initVisual():void {

			var geom:Geometry;
			var tex:BitmapTexture;
			var mat:TextureMaterial;

			_meshComponent = new MeshComponent();

			tex = new BitmapTexture( Bitmap( new EmbeddedResources.MonitorDiffusePNGAsset ).bitmapData );
			mat = new TextureMaterial( tex ); // TODO: clone materials
			
			geom = Geometry( AssetLibrary.getAsset( (_type == "small")? "MonitorS_geom" : "MonitorL_geom" ) ).clone();
			geom.scale( 100 );

			var mesh:Mesh = new Mesh( geom, mat );
			mesh.x = _initialX;
			mesh.y = -_initialY;
			mesh.z = _initialZ;
			mesh.rotationY = _initialRotation;
			_meshComponent.mesh = mesh;
		}

		override public function reset():void {
			super.reset();
			/*
			_physics.b2body.SetLinearVelocity( new V2() );
			_physics.b2body.SetAngularVelocity( 0 );
			_physics.b2body.SetTransform( new V2( _initialX / Settings.PHYSICS_SCALE, _initialY / Settings.PHYSICS_SCALE ), 0 );
			_physics.b2body.SetAwake( false );
			_physics.updateBodyMatrix( null );
			*/
		}
	}
}

import com.awaystudios.gloopahoop.*;
import com.awaystudios.gloopahoop.gameobjects.*;
import com.awaystudios.gloopahoop.gameobjects.components.*;

class MonitorPhysicsComponent extends PhysicsComponent {

	public function MonitorPhysicsComponent( gameObject:DefaultGameObject ) {
		super( gameObject );
		graphics.beginFill( gameObject.debugColor1 );
		graphics.drawRect( -GameSettings.BOX_SIZE / 2, -GameSettings.BOX_SIZE / 2, GameSettings.BOX_SIZE, GameSettings.BOX_SIZE );
	}

	public override function shapes():void {
		box( GameSettings.BOX_SIZE, GameSettings.BOX_SIZE );
	}
}
