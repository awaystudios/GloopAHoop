package com.awaystudios.gloopahoop.effects.splat
{
	import away3d.containers.*;
	import away3d.core.pick.*;
	import away3d.entities.*;
	
	import flash.geom.*;

	public class RaySplatter
	{
		public var numRays:uint = 1;
		public var apertureX:Number = 0;
		public var apertureY:Number = 0;
		public var apertureZ:Number = 0;
		public var sourcePosition:Vector3D;
		public var splatDirection:Vector3D;
		public var decals:Vector.<Mesh>;
		public var zOffset:Number = 1;
		public var targets:Vector.<Entity>;
		public var shrinkFactor:Number = 0.99;
		public var maxDistance:Number = 50;

		private var _minScale:Number = 1;
		private var _maxScale:Number = 1;
		private var _deltaScale:Number = 0;
		private var _maxDecals:uint;
		private var _decals:Vector.<Mesh>;
		private var _currentDecalIndex:uint;
		private var _raycastPicker:RaycastPicker;

		public function shrinkDecals():void {
			for( var i:uint, len:uint = _decals.length; i < len; ++i ) {
				var decal:Mesh = _decals[ i ];
				decal.scale( shrinkFactor );
			}
		}

		public function RaySplatter( maxDecals:uint = 10 ) {
			_maxDecals = maxDecals;
			_decals = new Vector.<Mesh>();
			_raycastPicker = new RaycastPicker(true);
			_raycastPicker.onlyMouseEnabled = false;
			sourcePosition = new Vector3D();
			splatDirection = new Vector3D( 0, 1, 0 );
		}

		public function evaluate():void
		{
			var rayPosition:Vector3D;
			var rayDirection:Vector3D;
			var pickingCollisionVO:PickingCollisionVO;
			
			for( var i:uint; i < numRays; ++i ) {
				// update ray position
				rayPosition = sourcePosition.clone();
				rayDirection = splatDirection.clone();
				if( numRays > 1 ) {
					rayDirection.x += rand( -apertureX, apertureX );
					rayDirection.y += rand( -apertureY, apertureY );
					rayDirection.z += rand( -apertureZ, apertureZ );
				}
				pickingCollisionVO = _raycastPicker.getEntityCollision(rayPosition, rayDirection, targets);
				// test
				if( pickingCollisionVO ) {

					// evaluate decal position
					var position:Vector3D = pickingCollisionVO.entity.sceneTransform.transformVector( pickingCollisionVO.localPosition );
					var distance:Number = position.subtract( sourcePosition ).length;
					if( distance > maxDistance ) continue;
					var scale:Number = _maxScale - distance * _deltaScale / maxDistance;
					placeDecalAt( position, scale, pickingCollisionVO.entity.scene );
				}
			}
		}

		private function placeDecalAt( position:Vector3D, scale:Number, scene:Scene3D ):void {
			var decal:Mesh = getNextDecal();
			decal.scale( scale );
			decal.position = position;
			scene.addChild( decal );
		}

		private function getNextDecal():Mesh {
			var decal:Mesh;
			if( _decals.length - 1 < _currentDecalIndex ) {
				var randDecalIndex:uint = Math.floor( Math.random() * decals.length );
				decal = decals[ randDecalIndex ].clone() as Mesh;
			}
			else {
				decal = _decals[ _currentDecalIndex ];
				decal.scaleX = decal.scaleY = decal.scaleZ = 1;
			}
			_decals.push( decal );
			_currentDecalIndex++;
			if( _currentDecalIndex > _maxDecals ) _currentDecalIndex = 0;
			return decal;
		}

		private function rand( min:Number, max:Number ):Number {
			return (max - min) * Math.random() + min;
		}

		public function get minScale():Number {
			return _minScale;
		}

		public function set minScale( value:Number ):void {
			_minScale = value;
			_deltaScale = _maxScale - _minScale;
		}

		public function get maxScale():Number {
			return _maxScale;
		}

		public function set maxScale( value:Number ):void {
			_maxScale = value;
			_deltaScale = _maxScale - _minScale;
		}
	}
}
