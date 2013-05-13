package com.awaystudios.gloopahoop.gameobjects
{

	import Box2DAS.Dynamics.*;
	
	import com.awaystudios.gloopahoop.gameobjects.components.*;

	public class MouseDummy extends DefaultGameObject
	{
		private var _isColliding:Boolean;
		private var _numColliders:int = 0;

		public function MouseDummy() {
			super();
			_physics = new MouseDummyPhysicsComponent( this );
		}

		public function resetColliders():void {
			_numColliders = 0;
		}

		override public function onCollidingWithSomethingStart( event:ContactEvent ):void {
			if( validateCollider( event.other ) ) {
				_numColliders++;
				_isColliding = _numColliders > 0;
			}
		}

		override public function onCollidingWithSomethingEnd( event:ContactEvent ):void {
			if( validateCollider( event.other ) ) {
				_numColliders--;
				_isColliding = _numColliders > 0;
			}
		}

		public function get isColliding():Boolean {
			return _isColliding;
		}

		private function validateCollider( fixture:b2Fixture ):Boolean {
			var otherGO:DefaultGameObject = getGameObject( fixture );
			if( otherGO is Star ) return false;
			else if( otherGO is Fan ) return false;
			else if( otherGO is GoalWall ) return false;
			return true;
		}

		private function getGameObject( fixture:b2Fixture ):DefaultGameObject {
			var otherPhysics:PhysicsComponent = fixture.m_userData as PhysicsComponent;
			return otherPhysics.gameObject;
		}
	}
}

import com.awaystudios.gloopahoop.*;
import com.awaystudios.gloopahoop.gameobjects.*;
import com.awaystudios.gloopahoop.gameobjects.components.*;

class MouseDummyPhysicsComponent extends PhysicsComponent {

	public function MouseDummyPhysicsComponent( gameObject:DefaultGameObject ) {
		super( gameObject );

		graphics.beginFill( 0x00FF00, 0.5 );
		graphics.drawCircle( 0, 0, GameSettings.HOOP_SCALE * GameSettings.HOOP_RADIUS );

		enableReportBeginContact();
		enableReportEndContact();
	}

	public override function shapes():void {
		circle( GameSettings.HOOP_SCALE * GameSettings.HOOP_RADIUS );
	}

	override public function create():void {
		super.create();
		b2body.SetSleepingAllowed( false );
		b2body.SetAwake( true );
		b2fixtures[ 0 ].SetSensor( true );
	}
}
