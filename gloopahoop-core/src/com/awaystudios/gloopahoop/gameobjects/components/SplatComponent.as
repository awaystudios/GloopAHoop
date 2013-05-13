package com.awaystudios.gloopahoop.gameobjects.components
{
	import Box2DAS.Collision.*;
	import Box2DAS.Common.*;
	import Box2DAS.Dynamics.*;
	import Box2DAS.Dynamics.Contacts.*;
	
	import Box2DAS.Dynamics.ContactEvent;
	
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.primitives.*;
	
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.effects.splat.*;
	
	import flash.geom.*;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class SplatComponent
	{
		
		private var _decalSplatter : RaySplatter;
		private var _physics : PhysicsComponent;
		private var _material:ColorMaterial;
		
		private var _inContact : Boolean;
		private var _cooldown : int;
		
		
		public function SplatComponent(physics : PhysicsComponent)
		{
			_physics = physics;
			_decalSplatter = new RaySplatter(GameSettings.GLOOP_DECAL_LIMIT_TOTAL);
			_decalSplatter.apertureX = 0.35;
			_decalSplatter.apertureY = 0.35;
			_decalSplatter.apertureZ = 0.5;
			_decalSplatter.maxDistance = 100;
			_decalSplatter.zOffset = -1;
			_decalSplatter.shrinkFactor = 0.999;
			_decalSplatter.minScale = 0.1;
			_decalSplatter.maxScale = 2;

			_material = new ColorMaterial( 0x00ff00 );
			var sphereDecal:Mesh = new Mesh( new SphereGeometry( 5, 8, 6 ), _material );
			_decalSplatter.decals = Vector.<Mesh>( [sphereDecal] );
			
			_physics.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
			_physics.addEventListener(ContactEvent.END_CONTACT, handleEndContact);
		}
		
		public function update(dt : Number) : void
		{
			_decalSplatter.shrinkDecals(); // TODO: respect time delta
			
			if (_inContact) {
				if (_cooldown <= 0) {
					var contacts:b2ContactEdge;
					
					if (_physics.b2body)
						contacts = _physics.b2body.GetContactList();
					
					if (contacts) {
						var wm : b2WorldManifold;
						var c : b2Contact;
						var p : V2;
						
						wm = new b2WorldManifold();
						c = contacts.contact;
						
						while (c) {
							if (c.IsTouching()) {
								c.GetWorldManifold(wm);
								if (wm.points.length) {
									p = wm.points[0];
									break;
								}
							}
							c = c.GetNext();
						}
						
						if (p) {
							splatter(wm.points[0]);
							_cooldown = GameSettings.GLOOP_SPLAT_COOLDOWN;
						}
					}
				}
			}
			
			_cooldown -= dt;
		}
		
		
		public function reset() : void
		{
			_inContact = false;
		}
		
		public function set splattables(value : Vector.<Entity>) : void
		{
			_decalSplatter.targets = value;
		}
		
		private function handleBeginContact(e : ContactEvent) : void
		{
			var otherPhysics : PhysicsComponent = e.other.m_userData as PhysicsComponent;
			if (!otherPhysics)
				return;
			var wm : b2WorldManifold = e.getWorldManifold();
			if (wm.points.length > 0)
			{
				_inContact = true;
			}
			
			_cooldown = 0;
		}
		
		private function handleEndContact(e : ContactEvent) : void
		{
			_inContact = false;
		}
		
		private function splatter(collisionPoint : V2) : void
		{
			// splat source is the gloop's position
			_decalSplatter.sourcePosition = new Vector3D(_physics.x, -_physics.y, 0);
			// splat direction depends contact normal
			var bodyPosition : V2 = _physics.b2body.GetPosition();
			_decalSplatter.splatDirection = new Vector3D((collisionPoint.x - bodyPosition.x), -(collisionPoint.y - bodyPosition.y), 0);
			// splat intensity ( num splats ) depends on body speed
			var linearVelocity : V2 = _physics.b2body.GetLinearVelocity();
			var speed : Number = linearVelocity.length();
			_decalSplatter.numRays = 1 + Math.min(Math.floor(GameSettings.GLOOP_DECAL_SPEED_FACTOR * speed), GameSettings.GLOOP_DECAL_LIMIT_PER_HIT);
			// perform splat
			if (speed > GameSettings.GLOOP_DECAL_MIN_SPEED)
			{
				_decalSplatter.evaluate();
			}
		}

		public function setLightPicker( picker:LightPickerBase ):void {
			_material.lightPicker = picker;
		}
	}

}