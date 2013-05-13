package com.awaystudios.gloopahoop.gameobjects.components
{
	
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.*;
	
	import Box2DAS.Common.*;
	import Box2DAS.Dynamics.*;
	
	import wck.*;
	
	public class PhysicsComponent extends BodyShape
	{
		public var _gameObject : DefaultGameObject;
		
		public function PhysicsComponent(gameObject : DefaultGameObject)
		{
			_gameObject = gameObject;
			allowDragging = false;
			awake = false;
			applyGravity = false;
			autoSleep = true;
		}

		public function enableReportBeginContact():void {
			reportBeginContact = true;
			if( !hasEventListener( ContactEvent.BEGIN_CONTACT ) ) {
				addEventListener( ContactEvent.BEGIN_CONTACT, onBeginContact );
			}
		}

		public function enableReportEndContact():void {
			reportEndContact = true;
			if( !hasEventListener( ContactEvent.END_CONTACT ) ) {
				addEventListener(ContactEvent.END_CONTACT, onEndContact);
			}
		}

		public function enableReportPreSolveContact():void {
			reportPreSolve = true;
			if( !hasEventListener( ContactEvent.PRE_SOLVE ) ) {
				addEventListener(ContactEvent.PRE_SOLVE, onPreSolveContact);
			}
		}

		public function disableReportBeginContact():void {
			reportBeginContact = false;
			if( hasEventListener( ContactEvent.BEGIN_CONTACT ) ) {
				removeEventListener( ContactEvent.BEGIN_CONTACT, onBeginContact );
			}
		}

		public function disableReportEndContact():void {
			reportEndContact = false;
			if( hasEventListener( ContactEvent.END_CONTACT ) ) {
				removeEventListener(ContactEvent.END_CONTACT, onEndContact);
			}
		}

		public function disableReportPreSolveContact():void {
			reportPreSolve = false;
			if( hasEventListener( ContactEvent.PRE_SOLVE ) ) {
				removeEventListener(ContactEvent.PRE_SOLVE, onPreSolveContact);
			}
		}

		public function setStatic(static : Boolean = true) : void
		{
			if (static)
			{
				type = 'Static';
			}
			else
			{
				type = 'Dynamic';
			}
		}
		
		public function moveTo(worldX:Number, worldY:Number ):void {
			var pos:V2 = new V2(worldX, worldY);
			
			// physics are not intialized, we can set them on the visual object and wck will read them from here
			if (!b2body) {
				x = pos.x;
				y = pos.y;
				return;
			}

			// transform point into physics coord space
			pos.x /= GameSettings.PHYSICS_SCALE;
			pos.y /= GameSettings.PHYSICS_SCALE;
			
			var angle:Number = b2body.GetAngle();
			
			b2body.SetTransform(pos, angle);
			updateBodyMatrix(null); // updates the 2d view, the 3d will update the next frame
		}
		
		/**
		 * Draws the object as seen by Box2D, useful for debugging, might be inaccurate if used after initialization phase
		 */
		public function drawBox2D() : void
		{
			graphics.clear();
			graphics.beginFill(_gameObject.debugColor1, .1);
			graphics.lineStyle(2, _gameObject.debugColor2, 1);
			for each (var fixture : b2Fixture in b2fixtures)
			{
				fixture.Draw(graphics, this.b2body.GetTransform(), 60);
			}
		}
		
		protected function onBeginContact(e : ContactEvent) : void
		{
			_gameObject.onCollidingWithSomethingStart( e );
			var gloop:Gloop = getGloop(e.other);
			if (!gloop) return;
			_gameObject.onCollidingWithGloopStart(gloop, e);
		}
		
		protected function onEndContact(e : ContactEvent ) : void
		{
			_gameObject.onCollidingWithSomethingEnd( e );
			var gloop:Gloop = getGloop(e.other);
			if (!gloop) return;
			_gameObject.onCollidingWithGloopEnd(gloop, e);
		}

		private function onPreSolveContact( e:ContactEvent ):void {
			_gameObject.onCollidingWithSomethingPreSolve( e );
			var gloop:Gloop = getGloop(e.other);
			if( !gloop ) return;
			_gameObject.onCollidingWithGloopPreSolve( gloop, e );
		}
		
		public function getGloop(fixture:b2Fixture):Gloop {
			var otherPhysics : PhysicsComponent = fixture.m_userData as PhysicsComponent;
			if (!otherPhysics) return null;
			var gloop : Gloop = otherPhysics.gameObject as Gloop;
			return gloop;
		}
		
		public function get gameObject() : DefaultGameObject
		{
			return _gameObject;
		}
		
		public function get isStatic() : Boolean
		{
			return type == 'Static';
		}
	
	}
}