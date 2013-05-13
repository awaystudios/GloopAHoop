package com.awaystudios.gloopahoop.gameobjects.components
{

	
	import Box2DAS.Common.V2;
	
	import away3d.debug.*;
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.screens.*;
	
	import flash.events.*;
	import flash.utils.*;

	public class GloopVisualComponent extends MeshComponent
	{
		private var _physics : PhysicsComponent;
		
		private var _stdAnim : VertexAnimationComponent;
		private var _splatAnim : VertexAnimationComponent;

		private var _smileMat:TextureMaterial;
		private var _sadMat:TextureMaterial;
		private var _ouchMat:TextureMaterial;
		private var _yippeeMat:TextureMaterial;

		private var _stdMesh : Mesh;
		private var _splatMesh : Mesh;
		
		private var _bounceVelocity:Number = 0;
		private var _bouncePosition:Number = 0;
		private var _facingRotation:Number = 0;
		
		private var _splatAngle : Number;
		private var _splatting : Boolean;

		public static const FACIAL_SMILE:uint = 0;
		public static const FACIAL_SAD:uint = 1;
		public static const FACIAL_OUCH:uint = 2;
		public static const FACIAL_YIPPEE:uint = 3;

		private var _currentFacial:uint;
		private var _facialRestoreTmr:Timer;
		private var _facialChangeFree:Boolean = true;

		private const FACIAL_EXPRESSION_TIME:uint = 250;

		public function setFacial( expression:uint ):void {

			_facialRestoreTmr.reset();
			_facialRestoreTmr.start();

			if( !_facialChangeFree || expression == _currentFacial ) {
				return;
			}

			_facialChangeFree = false;

			switch( expression ) {
				case FACIAL_OUCH: {
					_stdMesh.material = _ouchMat;
					break;
				}
				case FACIAL_SAD:
				{
					_stdMesh.material = _sadMat;
					break;
				}
				case FACIAL_SMILE:
				{
					_stdMesh.material = _smileMat;
					break;
				}
				case FACIAL_YIPPEE:
				{
					_stdMesh.material = _yippeeMat;
					break;
				}
			}

			_currentFacial = expression;

		}

		private function onFacialRestoreTimerComplete( event:TimerEvent ):void {
			_facialChangeFree = true;
			setFacial( FACIAL_SMILE );
		}

		public function GloopVisualComponent(physics : PhysicsComponent)
		{
			super();

			_physics = physics;

			init();

			_facialRestoreTmr = new Timer( FACIAL_EXPRESSION_TIME, 1 );
			_facialRestoreTmr.addEventListener( TimerEvent.TIMER_COMPLETE, onFacialRestoreTimerComplete );
		}

		private function init() : void
		{
			// Will be used as container for either
			// standard or splat mesh.
			mesh = new Mesh(null);
			
			initStandard();
			initSplat();
		}
		
		
		private function initStandard() : void
		{
			_stdMesh = AssetManager.instance.gloopStdAnimMesh;
			_stdAnim = AssetManager.instance.gloopStdAnimation;
			_sadMat = AssetManager.instance.sadMat;
			_smileMat = AssetManager.instance.smileMat;
			_ouchMat = AssetManager.instance.ouchMat;
			_yippeeMat = AssetManager.instance.yippeeMat;

			if( GameSettings.SHOW_GLOOP_AXIS ) {
				var tracer:Trident = new Trident( 100 );
				mesh.addChild( tracer );
			}

			mesh.addChild(_stdMesh);
		}
		
		
		private function initSplat() : void
		{
			_splatMesh = AssetManager.instance.gloopSplatAnimMesh;
			_splatAnim = AssetManager.instance.gloopSplatAnimation;
			mesh.addChild( _splatMesh );
		}
		
		
		public override function setLightPicker(picker:LightPickerBase):void
		{
			_stdMesh.material.lightPicker = picker;
			_splatMesh.material.lightPicker = picker;

			_sadMat.lightPicker = picker;
			_smileMat.lightPicker = picker;
			_ouchMat.lightPicker = picker;
			_yippeeMat.lightPicker = picker;
		}
		
		
		public function splat(angle : Number) : void
		{
			_stdMesh.visible = false;
			_splatMesh.visible = true;
			
			_splatAnim.play('splat');
			
			_splatAngle = 180-angle;
			_splatting = true;
		}
		
		
		public function reset() : void
		{
			_splatAnim.stop();

			_splatMesh.visible = false;
			_stdMesh.visible = true;
			
			_bounceVelocity = 0;
			_bouncePosition = 0;
			_splatting = false;
		}
		
		
		public function bounceAndFaceDirection(bounceAmount:Number):void{
			var velocity:V2 = _physics.linearVelocity;
			
			if (velocity.length() < 2){
				_facingRotation = 0;
			} else {
				_facingRotation = Math.atan2(velocity.x, velocity.y) / Math.PI * 180 - 180;
			}
			
			_bounceVelocity = bounceAmount;
		}
		
		
		public function update(dt : Number, speed : Number, vx : Number) : void
		{
			if (_splatting) {
				mesh.rotationZ = _splatAngle;
			}
			else {
				_facingRotation -= vx * .20;
				mesh.rotationZ = _facingRotation;
				
				_bounceVelocity -= (_bouncePosition - 0.5) * .1;
				_bounceVelocity *= .8;
				
				_bouncePosition += _bounceVelocity;
				
				speed = Math.min(speed, 3);
	
				mesh.scaleY = Math.max(.2, .5 + _bouncePosition) + speed * 0.05;
				mesh.scaleX = 1 + (1 - mesh.scaleY)
			}
		}

		public function get stdMesh():Mesh {
			return _stdMesh;
		}

		public function get splatMesh():Mesh {
			return _splatMesh;
		}
	}
}