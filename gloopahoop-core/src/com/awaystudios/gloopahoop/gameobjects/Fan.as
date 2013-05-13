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
	import com.awaystudios.gloopahoop.sounds.*;
	import com.awaystudios.gloopahoop.utils.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	

	public class Fan extends DefaultGameObject implements IButtonControllable
	{
		private var _btnGroup:uint;
		private var _blades:Mesh;
		private var _isOn:Boolean;
		private var _activeFanStrength:Object = { t:0 };
		private var _gloop:Gloop;

		override public function dispose():void {
//			_blades = null;
		}

		public function Fan( worldX:Number = 0, worldY:Number = 0, rotation:Number = 0, btnGroup:uint = 0 ) {
			super();

			_btnGroup = btnGroup;

			_physics = new FanPhysicsComponent( this );
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.enableReportBeginContact();
			_physics.enableReportEndContact();
			_physics.rotation = rotation;

			_physics.fixedRotation = true;
			_physics.applyGravity = false;
			_physics.linearDamping = 100;

			_physics.setStatic();

			var fanMaterial:ColorMaterial = new ColorMaterial( 0xCCCCCC );

			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(Geometry(AssetLibrary.getAsset('FanAxis_geom')), fanMaterial );
			_meshComponent.mesh.rotationZ = rotation;

			_blades = new Mesh(Geometry(AssetLibrary.getAsset('FanBlades_geom')), new TextureMaterial(new BitmapTexture( Bitmap( new EmbeddedResources.FanDiffusePNGAsset ).bitmapData)));
			_meshComponent.mesh.addChild( _blades );
		}

		override public function update( dt:Number ):void {
			super.update( dt );
			if( _isOn ) {
				_blades.rotationY += 25 * _activeFanStrength.t; // TODO: implement on/off inertia to physics as well?
			}
			
			if(_isOn && _gloop){
				var distanceToFan:Number = _gloop.physics.b2body.GetWorldCenter().subtract( _physics.b2body.GetWorldCenter() ).length();
				var impulse:V2 = _physics.b2body.GetWorldVector( new V2( 0, - GameSettings.FAN_POWER * ( 1 / distanceToFan + 1 ) * dt ) );
				_gloop.physics.b2body.ApplyImpulse( impulse, _gloop.physics.b2body.GetWorldCenter() ); // apply up impulse
			}
		}
		
		override public function onCollidingWithGloopStart( gloop:Gloop, event:ContactEvent = null ):void {
			super.onCollidingWithGloopStart(gloop);
			_gloop = gloop;
		}
		
		override public function onCollidingWithGloopEnd( gloop:Gloop, event:ContactEvent = null ):void {
			super.onCollidingWithGloopEnd(gloop);
			_gloop = null;
		}

		public function toggleOn():void {
			if( _isOn ) return;
			_isOn = true;
			var d : Number = Math.random() * 0.2;
			TweenLite.to( _activeFanStrength, GameSettings.FAN_ON_OFF_TIME, { delay: d, t:1, ease:Cubic.easeIn } );
			SoundManager.play( Sounds.GAME_FAN, SoundManager.CHANNEL_FAN );
		}

		public function toggleOff():void {
			if( !_isOn ) return;
			TweenLite.to( _activeFanStrength, GameSettings.FAN_ON_OFF_TIME, { t:0, onComplete:onToggleOffComplete } );
			SoundManager.stop( SoundManager.CHANNEL_FAN );
		}

		private function onToggleOffComplete():void {
			_isOn = false;
		}
		
		public function get buttonGroup():uint {
			return _btnGroup;
		}
	}
}

import Box2DAS.Common.V2;

import com.awaystudios.gloopahoop.*;
import com.awaystudios.gloopahoop.gameobjects.*;
import com.awaystudios.gloopahoop.gameobjects.components.*;

class FanPhysicsComponent extends PhysicsComponent
{
	public function FanPhysicsComponent( gameObject:DefaultGameObject ) {
		super( gameObject );

		graphics.beginFill( gameObject.debugColor1 );
		graphics.drawRect( -GameSettings.FAN_BODY_WIDTH / 2, -GameSettings.FAN_BODY_HEIGHT / 2, GameSettings.FAN_BODY_WIDTH, GameSettings.FAN_BODY_HEIGHT );

		graphics.beginFill( gameObject.debugColor2 );
		graphics.drawRect( -GameSettings.FAN_AREA_WIDTH / 2, -GameSettings.FAN_BODY_HEIGHT - GameSettings.FAN_AREA_HEIGHT, GameSettings.FAN_AREA_WIDTH, GameSettings.FAN_AREA_HEIGHT );
	}

	public override function shapes():void {
		// defines fan body fixture
		box( GameSettings.FAN_BODY_WIDTH, GameSettings.FAN_BODY_HEIGHT );
		// defines fan area fixture
		box( GameSettings.FAN_AREA_WIDTH, GameSettings.FAN_AREA_HEIGHT, new V2( 0, -GameSettings.FAN_BODY_HEIGHT - GameSettings.FAN_AREA_HEIGHT + GameSettings.FAN_BODY_HEIGHT / 2 ) );
	}

	override public function create():void {
		super.create();
		b2fixtures[1].SetSensor( true );
	}
}