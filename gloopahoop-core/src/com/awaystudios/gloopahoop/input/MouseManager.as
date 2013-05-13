package com.awaystudios.gloopahoop.input
{

	import com.awaystudios.gloopahoop.utils.*;
	
	import away3d.containers.*;
	
	import flash.events.*;
	import flash.geom.*;

	/*
			 * Translates 3D view mouse interactions to 2D physics view mouse interactions.
			 * */
	public class MouseManager
	{
		private var _planeNormal:Vector3D;
		private var _planeD:Number;
		private var _intersection:Vector3D;
		private var _intersectionPoint:Point;

		protected var _view:View3D;
		protected var _mouseDown:Boolean = false;
		private var _mouseIsOut:Boolean;
		private var _needMouseLeaveHack:Boolean;

		public const PLANE_POSITION:Vector3D = new Vector3D( 0, 0, 0 );

		public function MouseManager(view:View3D) {
			_view = view;
			_planeNormal = new Vector3D( 0, 0, -1 );
			_planeD = -_planeNormal.dotProduct( PLANE_POSITION );
			_intersection = new Vector3D();
			_intersectionPoint = new Point();

			// need mouse leave hack?
			if( !PlatformUtil.isRunningOnMobile() ) {
				if( PlatformUtil.isRunningOnSafari() ) {
					_needMouseLeaveHack = true;
				}
			}

		}

		public function activate():void {
			_view.addEventListener( MouseEvent.MOUSE_DOWN, onViewMouseDown );
			_view.stage.addEventListener( MouseEvent.MOUSE_UP, onViewMouseUp );

			if( _needMouseLeaveHack ) {
				_view.stage.addEventListener( MouseEvent.MOUSE_MOVE, updateMouseLeave );
			}
			_view.stage.addEventListener( Event.MOUSE_LEAVE, onViewMouseUp );
		}

		public function deactivate():void {
			_view.removeEventListener( MouseEvent.MOUSE_DOWN, onViewMouseDown );
			_view.stage.removeEventListener( MouseEvent.MOUSE_UP, onViewMouseUp );

			if( _needMouseLeaveHack ) {
				_view.stage.addEventListener( MouseEvent.MOUSE_MOVE, updateMouseLeave );
			}
			_view.stage.addEventListener( Event.MOUSE_LEAVE, onViewMouseUp );
		}

		public function update():void {
			// evaluate mouse ray intersection with virtual plane
			// cast a ray from the camera
			var rayPosition:Vector3D = _view.camera.scenePosition;
			var rayDirection:Vector3D = _view.unproject( _view.mouseX, _view.mouseY, 1 ).subtract(rayPosition);
			rayDirection.normalize();
			// evaluate plane intersection
			var planeNormalDotRayPosition:Number = _planeNormal.dotProduct( rayPosition );
			var planeNormalDotRayDirection:Number = _planeNormal.dotProduct( rayDirection );
			var t:Number = -( planeNormalDotRayPosition + _planeD ) / planeNormalDotRayDirection;
			_intersection.x = rayPosition.x + t * rayDirection.x;
			_intersection.y = rayPosition.y + t * rayDirection.y;
			_intersection.z = rayPosition.z + t * rayDirection.z;
			_intersectionPoint.x = _intersection.x;
			_intersectionPoint.y = -_intersection.y;
		}

		protected function onViewMouseDown(e:MouseEvent):void {
			_mouseDown = true;
			update();
		}

		protected function onViewMouseUp(e:Event):void {
			_mouseDown = false;
			update();
		}

		public function get projectedMouseX():Number{
			return _intersection.x;
		}

		public function get projectedMouseY():Number{
			return -_intersection.y;
		}

		public function get projectedMousePosition():Point {
			return _intersectionPoint;
		}

		public function updateMouseLeave( event:Event ):void {
			if( _view.stage.mouseX < 0 ||
				_view.stage.mouseX > _view.stage.stageWidth ||
				_view.stage.mouseY < 0 ||
				_view.stage.mouseY > _view.stage.stageHeight ) {
				if( !_mouseIsOut ) {
					_mouseIsOut = true;
					_view.stage.dispatchEvent( new Event( Event.MOUSE_LEAVE ) );
				}
			}
			else if( _mouseIsOut ) {
				_mouseIsOut = false;
				_view.stage.dispatchEvent( new Event( "mouseEnter" ) );
			}
		}
	}
}
