package com.awaystudios.gloopahoop.gameobjects
{

	import Box2DAS.Dynamics.*;
	
	import away3d.core.base.*;
	import away3d.entities.*;
	import away3d.library.*;
	import away3d.materials.*;
	
	import com.awaystudios.gloopahoop.gameobjects.components.*;
	import com.awaystudios.gloopahoop.gameobjects.events.*;
	import com.awaystudios.gloopahoop.sounds.*;
	
	public class Star extends DefaultGameObject
	{
		private var _animComponent:VertexAnimationComponent;
		private var _touched:Boolean = false;
		private var _randomRotation : Number;
		
		public function Star(worldX:Number = 0, worldY:Number = 0)
		{
			_physics = new StarPhysicsComponent(this);
			_physics.x = worldX;
			_physics.y = worldY;
			_physics.applyGravity = false;
			_physics.isSensor = true;
			_physics.enableReportBeginContact();
			
			initVisual();
		}
		
		private function initVisual() : void
		{
			var geom : Geometry;
			var mat : ColorMaterial;

			geom = Geometry(AssetLibrary.getAsset('StarFrame0_geom')).clone();
			mat = new ColorMaterial(0x3DF120);
			/* TODO: share materials?
			cannot share materials between differently animated entities ( would need to improve Away3D for this )
			dave says that you actually can
			David Lenaerts: you can, you just need to be sure that you don't assign the material when either of the targets still has a differeny animation
			David Lenaerts: easiest thing to do is to decouple the material until everything else is set
			* */

			_meshComponent = new MeshComponent();
			_meshComponent.mesh = new Mesh(geom, mat);

			_animComponent = new VertexAnimationComponent(_meshComponent.mesh);
			_animComponent.addClip('seq', [
				Geometry(AssetLibrary.getAsset('StarFrame0_geom')),
				Geometry(AssetLibrary.getAsset('StarFrame1_geom')),
				Geometry(AssetLibrary.getAsset('StarFrame2_geom')),
				Geometry(AssetLibrary.getAsset('StarFrame3_geom')),
				Geometry(AssetLibrary.getAsset('StarFrame4_geom')),
			], 600);
			_animComponent.play('seq');

		}
		
		override public function reset():void {
			super.reset();
			_touched = false;
			_meshComponent.mesh.visible = true;
			
			_randomRotation = Math.random() * 360;
		}
		
		override public function update(dt:Number):void
		{
			super.update(dt);
			
			_meshComponent.mesh.rotationZ = _randomRotation;
		}
		
		override public function onCollidingWithGloopStart( gloop:Gloop, event:ContactEvent = null ):void {
			super.onCollidingWithGloopStart(gloop);
			if (_touched) return;
			_touched = true;
			_meshComponent.mesh.visible = false;
			
			SoundManager.play(Sounds.GAME_STAR);
			
			dispatchEvent(new GameObjectEvent(GameObjectEvent.GLOOP_COLLECT_STAR, this));
		}
		
		override public function get debugColor1():uint {
			return 0x01e6f1;
		}

		override public function dispose():void {
//			_animComponent = null;
		}
	}
}

import com.awaystudios.gloopahoop.*;
import com.awaystudios.gloopahoop.gameobjects.*;
import com.awaystudios.gloopahoop.gameobjects.components.*;

class StarPhysicsComponent extends PhysicsComponent
{
	
	public function StarPhysicsComponent(gameObject:DefaultGameObject)
	{
		super(gameObject);
		graphics.beginFill(gameObject.debugColor1);
		graphics.drawCircle(0, 0, GameSettings.STAR_RADIUS);
	}
	
	public override function shapes() : void
	{
		circle(GameSettings.STAR_RADIUS);
	}
	
	override public function create():void {
		super.create();
	}
}