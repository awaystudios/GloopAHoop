package com.awaystudios.gloopahoop.gameobjects.hoops
{
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Fixture;
	
	import away3d.core.base.*;
	import away3d.library.*;
	
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.*;
	import com.awaystudios.gloopahoop.sounds.*;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class RocketHoop extends Hoop {

		private var _onSideCollision:Boolean = false;

		public function RocketHoop(worldX:Number = 0, worldY:Number = 0, rotation:Number = 0, movable:Boolean = true, rotatable:Boolean = true) {
			super(0x3f7fff, worldX, worldY, rotation, movable, rotatable);
			_physics.enableReportPreSolveContact();
//			_physics.enableReportBeginContact();
			_resolveGloopCollisions = true;
			_physics.restitution = 0;
		}

		/*override public function onCollidingWithGloopStart( gloop:Gloop, event:ContactEvent = null):void {

		}*/

		override public function onCollidingWithGloopPreSolve( gloop:Gloop, event:ContactEvent = null ):void {

			var normal:V2 = event.normal;

			_onSideCollision = false;
			if( normal ) {

				var localSpaceNormal:V2 = _physics.b2body.GetLocalVector( normal );

				// side hits
				if( ( Math.abs( localSpaceNormal.x ) > 0.01 ) ) {
					// regular collision
					_onSideCollision = true;
					return;
				}

				// kill incident velocity
				gloop.physics.b2body.SetLinearVelocity( new V2( 0, 0 ) );

				// apply impulse on the opposite of the hoop
				// direction and strength are determined by the hoop
				event.normal.normalize();
				normal.multiplyN( -GameSettings.ROCKET_POWER );
				gloop.physics.b2body.ApplyImpulse( normal, _physics.b2body.GetWorldCenter() );

				event.contact.SetEnabled( false );
			}

			// play sound
			var fixture:b2Fixture = event.fixture;
			if( !fixture.IsSensor() ) {
				if( !_onSideCollision ) {
					SoundManager.play( Sounds.GAME_ROCKET );
				}
			}
		}
		
		protected override function getIconGeometry() : Geometry
		{
			return Geometry(AssetLibrary.getAsset('RocketIcon_geom'));
		}

		public function get onSideCollision():Boolean {
			return _onSideCollision;
		}
	}

}