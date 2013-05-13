package com.awaystudios.gloopahoop.effects
{

	import com.awaystudios.gloopahoop.*;
	
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	

	public class PathTracer extends ObjectContainer3D
	{
		private var _poolSize : uint;
		
		private var _path : Vector.<Mesh>;
		private var _pointsTraced : uint;
		
		private var _minScale : Number;
		private var _maxScale : Number;
		private var _decayScale : Number;

		public function PathTracer(poolSize : uint = 20)
		{
			super();
			
			_poolSize = poolSize;
			_minScale = GameSettings.TRACE_MIN_SCALE;
			_maxScale = GameSettings.TRACE_MAX_SCALE;
			
			init();
		}
		
		private function init() : void
		{
			var i : uint;
			var mat : MaterialBase;
			var geom : Geometry;
			
			geom = new SphereGeometry( 5 );
			mat = new ColorMaterial( 0xFFFFFF );
			
			_path = new Vector.<Mesh>(_poolSize, true);
			for (i=0; i<_poolSize; i++) {
				_path[i] = new Mesh(geom, mat);
			}
			
			_pointsTraced = 0;
		}
		
		
		public function get hasMore() : Boolean
		{
			return (_pointsTraced < _poolSize);
		}
		
		
		public function reset() : void
		{
			var i : uint;
			
			for (i=0; i<_pointsTraced; i++) {
				removeChild(_path[i]);
			}
			
			_decayScale = 1;
			_pointsTraced = 0;
		}
		

		public function tracePoint( x:Number, y:Number, z:Number ):void {
			var entry : Mesh;
			
			entry = _path[_pointsTraced++];
			entry.x = x;
			entry.y = y;
			entry.z = z;
			entry.scaleX = entry.scaleY = entry.scaleZ = rand(_minScale, _maxScale) * _decayScale;
			addChild( entry );
			
			if ((_poolSize-_pointsTraced) < 10)
				_decayScale -= 0.1;
		}

		private function rand(min:Number, max:Number):Number
		{
		    return (max - min)*Math.random() + min;
		}
	}
}
