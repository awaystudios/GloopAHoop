package com.awaystudios.gloopahoop.gameobjects.hoops
{
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import away3d.core.base.*;
	import away3d.entities.*;
	import away3d.library.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.*;
	import com.awaystudios.gloopahoop.gameobjects.components.*;
	import com.awaystudios.gloopahoop.level.*;

	//import mx.events.CollectionEvent;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Hoop extends DefaultGameObject implements IMouseInteractive
	{
		private var _color : uint;
		
		//protected var _iconMesh : Mesh;
		
		protected var _rotatable:Boolean = true;
		protected var _draggable:Boolean = true;
		protected var _resolveGloopCollisions:Boolean = false;
		
		private var _material:ColorMaterial;

		public function Hoop(color : uint, worldX : Number = 0, worldY : Number = 0, rotation : Number = 0, draggable:Boolean = true, rotatable:Boolean = true)
		{
			_color = color;
			_draggable = draggable;
			_rotatable = rotatable;
			
			_physics = new HoopPhysicsComponent(this);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.rotation = rotation;

			initVisual()
		}
		
		
		private function initVisual() : void
		{
			var geom : Geometry;
			
			_material = new ColorMaterial(_color);

			geom = Geometry(AssetLibrary.getAsset('Hoop_geom'));

			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(geom, _material);

			//_iconMesh = new Mesh(getIconGeometry(), _material);
			//_meshComponent.mesh.addChild(_iconMesh);

			if( _draggable ) { // TODO: use cloned mesh from asset library
				var cylinder:Mesh = new Mesh( new CylinderGeometry(30, 30, 20, 32, 1, true, true, true, false), _material);
				cylinder.z = 100;
				_meshComponent.mesh.addChild( cylinder );
			} else if( _rotatable ) {
				//var circle:Mesh = new Mesh( new TorusGeometry(30, 2.5, 32, 8, false), _material);
				//circle.z = 100;
				//_meshComponent.mesh.addChild( circle );
			}

			if( _rotatable ) { // TODO: use cloned mesh from asset library
				createPole(0);
			} else {
				createPole(20);
				createPole(-20);
			}

			_meshComponent.mesh.scale( GameSettings.HOOP_SCALE );
		}

		private function createPole(offset:Number):void {
			var poleLength:Number = 500;
			var poleRadius:Number = 5;
			var hoopRadius:Number = ( _meshComponent.mesh.bounds.max.x - _meshComponent.mesh.bounds.min.x ) / 2;
			var pole:Mesh = new Mesh( new CylinderGeometry( poleRadius, poleRadius, poleLength ), _material );
			pole.z = poleLength / 2 + Math.sqrt(hoopRadius*hoopRadius - offset*offset);
			pole.x = offset;
			pole.rotationX = 90;
			_meshComponent.mesh.addChild( pole );
		}

		protected function getIconGeometry() : Geometry
		{
			// To be overridden
			return null;
		}
		
		
		public function onClick(mouseX:Number, mouseY:Number):void {
			if( inEditMode && rotatable ) {
				var pos:V2 = _physics.b2body.GetPosition();
				var angle:Number = _physics.b2body.GetAngle();
				_physics.b2body.SetTransform( pos, angle + GameSettings.HOOP_ROTATION_STEP / 180 * Math.PI );
				_physics.updateBodyMatrix( null ); // updates the 2d view, the 3d will update the next frame
			}
			HoopPhysicsComponent( _physics ).beingDragged = false;
		}
		
		public function onDragStart(mouseX:Number, mouseY:Number):void {
			if (!inEditMode) {
				return;
			}
			HoopPhysicsComponent( _physics ).beingDragged = true;
		}
		
		public function onDragUpdate(mouseX:Number, mouseY:Number):void {

		}

		public function onDragEnd(mouseX:Number, mouseY:Number):void {
			HoopPhysicsComponent( _physics ).beingDragged = false;
		}
		
		public override function onCollidingWithGloopStart( gloop:Gloop, event:ContactEvent = null ):void
		{
			super.onCollidingWithGloopStart(gloop);
			
			_meshComponent.mesh.scaleX = 1.1 * GameSettings.HOOP_SCALE;
			_meshComponent.mesh.scaleY = 1.1 * GameSettings.HOOP_SCALE;
			_meshComponent.mesh.scaleZ = 1.1 * GameSettings.HOOP_SCALE;
		}
		
		public override function update(dt:Number):void
		{
			super.update(dt);

			if( _meshComponent.mesh.scaleX > 1.01 * GameSettings.HOOP_SCALE ) {
				_meshComponent.mesh.scaleX += (1 - _meshComponent.mesh.scaleX) * 0.2;
			}
			else {
				_meshComponent.mesh.scaleX = GameSettings.HOOP_SCALE;
			}

			_meshComponent.mesh.scaleY = _meshComponent.mesh.scaleX;
			_meshComponent.mesh.scaleZ = _meshComponent.mesh.scaleX;
			
			//_iconMesh.rotationZ = -_meshComponent.mesh.rotationZ;
			//_iconMesh.rotationY += 0.5;
		}
		
		override public function setMode(value:Boolean):void {
			super.setMode(value);
			HoopPhysicsComponent(_physics).setMode(value);
		}

		public function get resolveGloopCollisions():Boolean {
			return _resolveGloopCollisions;
		}
		
		override public function get debugColor1():uint {
			return 0x947d3a;
		}
		
		override public function get debugColor2():uint {
			return 0xcebc84;
		}
		
		public function get rotatable():Boolean {
			return _rotatable;
		}
		
		public function get draggable():Boolean {
			return _draggable;
		}

		override public function onCollidingWithSomethingPreSolve( event:ContactEvent ):void {
			if( _mode == Level.EDIT_MODE ) {
				_physics.b2body.SetLinearVelocity( new V2() );
			}
		}
	}

}

import com.awaystudios.gloopahoop.*;
import com.awaystudios.gloopahoop.gameobjects.*;
import com.awaystudios.gloopahoop.gameobjects.components.*;
import com.awaystudios.gloopahoop.gameobjects.hoops.*;

class HoopPhysicsComponent extends PhysicsComponent
{
	public function HoopPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);

		graphics.beginFill( gameObject.debugColor1 );
		graphics.drawCircle( 0, 0, GameSettings.HOOP_SCALE * GameSettings.HOOP_RADIUS * .8);
		graphics.endFill();
		graphics.beginFill(gameObject.debugColor2);
		graphics.drawRect( -GameSettings.HOOP_SCALE * GameSettings.HOOP_RADIUS, -GameSettings.HOOP_SCALE * GameSettings.HOOP_RADIUS / 6,
			GameSettings.HOOP_SCALE * GameSettings.HOOP_RADIUS * 2, GameSettings.HOOP_SCALE * GameSettings.HOOP_RADIUS / 3);
		graphics.endFill();

		allowDragging = true;
		linearDamping = 9999999;
		angularDamping = 9999999;
		density = 9999;
		restitution = 0;
		fixedRotation = true;
		applyGravity = false;
		enableReportBeginContact();
		enableReportEndContact();
	}

	public override function shapes() : void
	{
		box( GameSettings.HOOP_SCALE * GameSettings.HOOP_RADIUS * 2, GameSettings.HOOP_SCALE * GameSettings.HOOP_RADIUS / 3);
		circle( GameSettings.HOOP_SCALE * GameSettings.HOOP_RADIUS * .8);
	}
	
	override public function create():void {
		super.create();
		setStatic( true );
	}
	
	public function set beingDragged( value:Boolean ):void {
		if (!b2body) return;
		if( value ) {
			allowDragging = true;
			setStatic( false );
		} else {
			allowDragging = false;
			b2fixtures[0].SetSensor( !Hoop( gameObject ).resolveGloopCollisions );
			setStatic( true );
		}
	}

	public function setMode( playMode:Boolean ):void {
		if (!b2body) return;
		if( !playMode ) {
			b2fixtures[0].SetSensor( true );
			b2fixtures[1].SetSensor( false );
		}
		else {
			b2fixtures[0].SetSensor( false );
			b2fixtures[1].SetSensor( true );
		}
	}
}