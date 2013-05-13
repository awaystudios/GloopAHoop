package com.awaystudios.gloopahoop.gameobjects
{
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import away3d.core.base.*;
	import away3d.entities.*;
	import away3d.library.*;
	import away3d.materials.*;
	import away3d.textures.*;
	
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.components.*;
	import com.awaystudios.gloopahoop.utils.*;
	
	import flash.display.*;

	public class Box extends DefaultGameObject
	{
		private var _initialX:Number;
		private var _initialY:Number;

		public function Box( worldX:Number = 0, worldY:Number = 0 ) {

			super();

			_physics = new BoxPhysicsComponent( this );
			_physics.x = _initialX = worldX;
			_physics.y = _initialY = worldY;
			_physics.applyGravity = true;
			_physics.restitution = 0.5;
			_physics.friction = 0.8;
			_physics.inertiaScale = 2;
//			_physics.enableReportBeginContact();
			_physics.enableReportPreSolveContact()
			_physics.density = GameSettings.BOX_DENSITY;

			initVisual();
		}

		override public function onCollidingWithSomethingPreSolve( event:ContactEvent ):void {
			var speed:Number = _physics.b2body.GetLinearVelocity().length();
			if( speed > 1 ) {
				//SoundManager.play( Sounds.GAME_BOING, SoundManager.CHANNEL_MAIN );
			}
		}

		private function initVisual():void {

			var geom:Geometry;
			var tex:BitmapTexture;
			var mat:TextureMaterial;

			_meshComponent = new MeshComponent();

			tex = new BitmapTexture( Bitmap( new EmbeddedResources.BoxDiffusePNGAsset ).bitmapData );
			mat = new TextureMaterial( tex ); // TODO: clone materials

//			geom = new CubeGeometry();
			geom = Geometry( AssetLibrary.getAsset( 'BOX' ) ).clone();
			geom.scale( 0.33*0.9 );

			_meshComponent.mesh = new Mesh( geom, mat );

		}

		override public function reset():void {
			super.reset();
			_physics.b2body.SetLinearVelocity( new V2() );
			_physics.b2body.SetAngularVelocity( 0 );
			_physics.b2body.SetTransform( new V2( _initialX / GameSettings.PHYSICS_SCALE, _initialY / GameSettings.PHYSICS_SCALE ), 0 );
			_physics.b2body.SetAwake( false );
			_physics.updateBodyMatrix( null );
		}

		override public function setMode( playMode:Boolean ):void {
			super.setMode( playMode );
			BoxPhysicsComponent( _physics ).setMode( playMode );
		}
	}
}

import com.awaystudios.gloopahoop.*;
import com.awaystudios.gloopahoop.gameobjects.*;
import com.awaystudios.gloopahoop.gameobjects.components.*;

class BoxPhysicsComponent extends PhysicsComponent {

	public function BoxPhysicsComponent( gameObject:DefaultGameObject ) {
		super( gameObject );
		graphics.beginFill( gameObject.debugColor1 );
		graphics.drawRect( -GameSettings.BOX_SIZE / 2, -GameSettings.BOX_SIZE / 2, GameSettings.BOX_SIZE, GameSettings.BOX_SIZE );
	}

	public override function shapes():void {
		box( GameSettings.BOX_SIZE, GameSettings.BOX_SIZE );
	}

	override public function create():void {
		super.create();
	}

	public function setMode( playMode:Boolean ):void {

		if( !b2body ) return;

		if( playMode ) {
			setStatic( false );
			applyGravity = true;
		}
		else {
			setStatic( true );
			applyGravity = false;
//			b2body.SetAwake( false );
		}
	}

}
