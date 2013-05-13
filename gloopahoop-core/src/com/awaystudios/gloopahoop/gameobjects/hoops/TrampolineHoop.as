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
	public class TrampolineHoop extends Hoop {

		private var _onSideCollision:Boolean = false;

		public function TrampolineHoop(worldX:Number = 0, worldY:Number = 0, rotation:Number = 0, movable:Boolean = true, rotatable:Boolean = true) {
			super(0xe9270e, worldX, worldY, rotation, movable, rotatable);
			_physics.restitution = GameSettings.TRAMPOLINE_RESTITUTION;
			_physics.enableReportPreSolveContact();
//			_physics.enableReportBeginContact();
			_resolveGloopCollisions = true;
		}

		/*override public function onCollidingWithGloopStart( gloop:Gloop, event:ContactEvent = null):void {

		}*/

		public override function onCollidingWithGloopPreSolve( gloop:Gloop, e:ContactEvent = null ):void {
			_onSideCollision = false;
			if( e.normal ) {
				var localSpaceNormal:V2 = _physics.b2body.GetLocalVector( e.normal );
				if( !( Math.abs( localSpaceNormal.x ) > 0.01 ) ) { // if not hit from the sides
					_physics.restitution = GameSettings.TRAMPOLINE_RESTITUTION;
				}
				else {
					_onSideCollision = true;
					_physics.restitution = 0; // use wall restitution here ( for now its the default 0 )
				}
			}

			var fixture:b2Fixture = e.fixture;
			if( fixture.IsSensor() ) return;

			if( _onSideCollision ) return;

			var speed:Number = gloop.physics.b2body.GetLinearVelocity().length();
			if( speed > 1 ) {
				SoundManager.play( Sounds.GAME_TRAMPOLINE );
			}
		}
		
		protected override function getIconGeometry() : Geometry
		{
			return Geometry(AssetLibrary.getAsset('SpringIcon_geom'));
		}

		public function get onSideCollision():Boolean {
			return _onSideCollision;
		}
	}

}