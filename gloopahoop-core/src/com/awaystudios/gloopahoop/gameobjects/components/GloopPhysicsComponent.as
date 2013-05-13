package com.awaystudios.gloopahoop.gameobjects.components
{
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.*;

	public class GloopPhysicsComponent extends PhysicsComponent
	{
		public function GloopPhysicsComponent( gameObject:DefaultGameObject ) {
			super( gameObject );
			
			graphics.beginFill( gameObject.debugColor1 );
			graphics.drawCircle( 0, 0, GameSettings.GLOOP_RADIUS );
			graphics.beginFill( gameObject.debugColor2 );
			graphics.drawRect( -GameSettings.GLOOP_RADIUS / 2, -GameSettings.GLOOP_RADIUS / 2, GameSettings.GLOOP_RADIUS, GameSettings.GLOOP_RADIUS );
		}
		
		public override function shapes():void {

			circle( GameSettings.GLOOP_RADIUS );

		}
		
		override public function create():void {

			super.create();

			autoSleep = false;
		}
	}
}