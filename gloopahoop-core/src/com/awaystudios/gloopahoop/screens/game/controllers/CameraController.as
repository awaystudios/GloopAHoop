package com.awaystudios.gloopahoop.screens.game.controllers
{

	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.*;
	import com.awaystudios.gloopahoop.input.*;
	
	import away3d.*;
	import away3d.cameras.*;
	import away3d.cameras.lenses.*;
	
	import flash.geom.*;

	use namespace arcane;

	public class CameraController
	{
		private var _inputManager : InputManager;
		private var _camera : Camera3D;
		private var _gloop : Gloop;
		private var _autoZoomIn:Boolean;
		
		private var _lookAtTarget : Vector3D;
		
		private var _boundsMinX : Number;
		private var _boundsMaxX : Number;
		private var _boundsMinY : Number;
		private var _boundsMaxY : Number;
		private var _boundsMinZ : Number;
		private var _boundsMaxZ : Number;

		private var _offX : Number;
		private var _offY : Number;
		
		private var _finishMode : Boolean;
		private var _finishTargetRotation : Number;
		
		private var _gloopIsFlying : Boolean;
		private var _interactedSinceGloopWasFired:Boolean;

		private var _cameraHorizontalFovFactor:Number;
		private var _cameraVerticalFovFactor:Number;

		private var _cameraPosition:Vector3D;
		
		public function CameraController(inputManager : InputManager, camera : Camera3D, gloop : Gloop)
		{
			_inputManager = inputManager;
			_camera = camera;
			_gloop = gloop;
			
			_lookAtTarget = new Vector3D();
		}

		public function firstReset():void {
			_autoZoomIn = true;
			_inputManager.resetInternalChanges();
		}

		public function resetOrientation() : void
		{
			_camera.rotationX *= 0.9;
			_camera.rotationY *= 0.9;
			_camera.rotationZ *= 0.9;
			_lookAtTarget.x = _cameraPosition.x;
			_lookAtTarget.y = _cameraPosition.y;
		}

		public function setGloopFired(offX : Number, offY : Number) : void
		{
			_gloopIsFlying = true;
			_offX = offX;
			_offY = offY;
			_interactedSinceGloopWasFired = false;
			_inputManager.resetInternalChanges();
		}
		
		
		public function setGloopMissed() : void
		{
			_finishMode = false;
		}
		
		
		
		public function setGloopFinishing(targetRotationRadians : Number) : void
		{
			_finishMode = true;
			_finishTargetRotation = targetRotationRadians;
		}
		
		
		public function setGloopIdle() : void
		{
			_finishMode = false;
			_gloopIsFlying = false;
		}
		
		
		public function setBounds(minX : Number, maxX : Number, minY : Number, maxY : Number ) : void {
			
			var pad:Number = GameSettings.STU_MODE? 100 : 0;
			
			_boundsMinX = minX - pad;
			_boundsMaxX = maxX + pad;
			_boundsMinY = minY - pad;
			_boundsMaxY = maxY + pad;
			_boundsMaxZ = -400;

			// evaluate camera fov factors
			var vViewAngle:Number = PerspectiveLens( _camera.lens ).fieldOfView / 2;
			_cameraVerticalFovFactor = Math.tan( vViewAngle * Math.PI / 180 );
			var cameraFocalLength:Number = 1 / Math.tan( vViewAngle * Math.PI / 180 );
			var hViewAngle:Number = Math.atan( PerspectiveLens( _camera.lens ).aspectRatio / cameraFocalLength ) * 180 / Math.PI;
			_cameraHorizontalFovFactor = Math.tan( hViewAngle * Math.PI / 180 );

			// evaluate and set min zoom
			var halfRangeX:Number = ( _boundsMaxX - _boundsMinX ) / 2;
			var halfRangeY:Number = ( _boundsMaxY - _boundsMinY ) / 2;
			var maxHorizontalZ:Number = halfRangeX / _cameraHorizontalFovFactor;
			var maxVerticalZ:Number = halfRangeY / _cameraVerticalFovFactor;
			
			if (GameSettings.STU_MODE)
				_boundsMinZ = -Math.max( maxHorizontalZ, maxVerticalZ ); // the furthest you can get
			else
				_boundsMinZ = -Math.min( maxHorizontalZ, maxVerticalZ ); // the furthest you can get

			_inputManager.panX = _camera.x =  _gloop.physics.x;
			_inputManager.panY = _camera.y = -_gloop.physics.y;
			_inputManager.zoom = _camera.z = _boundsMinZ;
			_cameraPosition = _camera.position.clone();

			// uncomment to trace pan containment values from level.
			/*var tracePlane:Mesh = new Mesh( new PlaneGeometry( 2 * halfRangeX, 2 * halfRangeY ), new ColorMaterial( 0x00FF00, 0.5 ) );
			 tracePlane.rotationX = -90;
			 _camera.scene.addChild( tracePlane );*/
		}

		private const FIRST_SHOT_ZOOM_IN:Number = 20;
		private const FIRST_SHOT_ZOOM_MAX:Number = -600;
		
		public function update() : void
		{
			var ease : Number;
			var lookAtGloop : Boolean;
			var targetPosition:Vector3D = new Vector3D( 0, 0, 1 );

			_interactedSinceGloopWasFired = _inputManager.panInternallyChanged;

			if( _autoZoomIn && _inputManager.zoomInternallyChanged ) {
				_autoZoomIn = false
			}

			// Default easing
			ease = 0.4;

			// evaluate target camera position
			var followMode:Boolean = !_interactedSinceGloopWasFired && _gloopIsFlying;
			if( followMode ) {

				_offX *= 0.9;
				_offY *= 0.9;
				targetPosition.x = _gloop.physics.x + _offX;
				targetPosition.y = -_gloop.physics.y + _offY;
				_inputManager.panX = targetPosition.x;
				_inputManager.panY = targetPosition.y;
				_camera.lookAt( new Vector3D( targetPosition.x, targetPosition.y, 0 ) );

				if( _autoZoomIn && _inputManager.zoom < FIRST_SHOT_ZOOM_MAX ) {
					_inputManager.zoom += FIRST_SHOT_ZOOM_IN;
				}
				
				if (_finishMode) {
					lookAtGloop = true;
					targetPosition.x += -150 * Math.sin(_finishTargetRotation);
					targetPosition.y += -150 * Math.cos(_finishTargetRotation);
//					targetPosition.x = _gloop.physics.x; // use these instead to visually debug gloop's impact with target from the side
//					targetPosition.y = -_gloop.physics.y;
					targetPosition.z = _boundsMaxZ;
					ease = 0.2;
				}
				else {
					lookAtGloop = false;
					targetPosition.z = _inputManager.zoom;
				}
			}
			else {
				lookAtGloop = false;
				_inputManager.update();
				targetPosition.x = _inputManager.panX;
				targetPosition.y = _inputManager.panY;
				targetPosition.z = _inputManager.zoom;
				resetOrientation();

				if( _autoZoomIn ) {
					_inputManager.zoom -= FIRST_SHOT_ZOOM_IN;
				}
			}

			var containmentTolerance:Number = 1;

			// evaluate containment
			var horizontalVisibleHalfDistance:Number = -_camera.z * _cameraHorizontalFovFactor;
			var verticalVisibleHalfDistance:Number = -_camera.z * _cameraVerticalFovFactor;
			var availablePanLeftDistance:Number = -(_boundsMinX * containmentTolerance) + targetPosition.x - horizontalVisibleHalfDistance;
			var availablePanRightDistance:Number = (_boundsMaxX * containmentTolerance) - targetPosition.x - horizontalVisibleHalfDistance;
			var availablePanDownDistance:Number = -(_boundsMinY * containmentTolerance) + targetPosition.y - verticalVisibleHalfDistance;
			var availablePanUpDistance:Number = (_boundsMaxY * containmentTolerance) - targetPosition.y - verticalVisibleHalfDistance;

			// contain X
			if( !_finishMode && !GameSettings.STU_MODE) {
				var containmentStrength:Number = 1;
				/*if( availablePanLeftDistance < 0 && availablePanRightDistance < 0 ) {
					_inputManager.panX = targetPosition.x = 0;
				}
				else */if( availablePanRightDistance < 0 ) {
					targetPosition.x += containmentStrength * availablePanRightDistance;
					_inputManager.panX = targetPosition.x;
				}
				else if( availablePanLeftDistance < 0 ) {
					targetPosition.x -= containmentStrength * availablePanLeftDistance;
					_inputManager.panX = targetPosition.x;
				}

				// contain Y
				/*if( availablePanUpDistance < 0 && availablePanDownDistance < 0 ) {
					_inputManager.panY = targetPosition.y = 0;
				}
				else */if( availablePanUpDistance < 0 ) {
					targetPosition.y += containmentStrength * availablePanUpDistance;
					_inputManager.panY = targetPosition.y;
				} else if( availablePanDownDistance < 0 ) {
					_inputManager.panY = targetPosition.y -= containmentStrength * availablePanDownDistance;
					_inputManager.panY = targetPosition.y;
				}
			}

			// contain Z
			if( targetPosition.z > _boundsMaxZ ) {
				targetPosition.z = _boundsMaxZ;
				_inputManager.zoom = _boundsMaxZ;
			} else if( targetPosition.z < _boundsMinZ ) {
				targetPosition.z = _boundsMinZ;
				_inputManager.zoom = _boundsMinZ;
			}

			// ease camera towards target position
			_cameraPosition.x += (targetPosition.x - _cameraPosition.x) * ease;
			_cameraPosition.y += (targetPosition.y - _cameraPosition.y) * ease;
			_cameraPosition.z += (targetPosition.z - _cameraPosition.z) * ease;
			
			if (lookAtGloop) {
				_lookAtTarget.x += (_gloop.meshComponent.mesh.x - _lookAtTarget.x) * ease;
				_lookAtTarget.y += (_gloop.meshComponent.mesh.y - _lookAtTarget.y) * ease;
			}
			else {
				_lookAtTarget.x += (_cameraPosition.x - _lookAtTarget.x) * ease;
				_lookAtTarget.y += (_cameraPosition.y - _lookAtTarget.y) * ease;
			}

			_camera.x = _cameraPosition.x;
			_camera.y = _cameraPosition.y + 150; // TODO: move to settings
			_camera.z = _cameraPosition.z;

			if( !followMode ) {
				_inputManager.panX = targetPosition.x;
				_inputManager.panY = targetPosition.y;
			}

			_camera.lookAt(_lookAtTarget);
		}
	}
}