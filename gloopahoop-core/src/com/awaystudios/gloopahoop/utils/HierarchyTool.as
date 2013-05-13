package com.awaystudios.gloopahoop.utils
{

	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.entities.*;
	import away3d.materials.lightpickers.*;

	public class HierarchyTool
	{
		static private var _meshCollection:Vector.<Mesh>;

		static public function recursiveApplyLightPicker( object:Object3D, picker:StaticLightPicker ):void {

			if( object is Mesh ) {
				var mesh:Mesh = object as Mesh;
				if( mesh.material ) {
					mesh.material.lightPicker = picker;
				}
			}

			if( object is ObjectContainer3D || object is Entity ) {
				var asContainer:ObjectContainer3D = object as ObjectContainer3D;
				for( var i:uint, len:uint = asContainer.numChildren; i < len; ++i ) {
					recursiveApplyLightPicker( asContainer.getChildAt( i ), picker );
				}
			}

		}

		static public function getAllMeshesInHierarchy( object:Object3D ):Vector.<Mesh> {
			_meshCollection = new Vector.<Mesh>();
			collectMesh( object );
			return _meshCollection;
		}

		static private function collectMesh( object:Object3D ):void {

			var i:uint, len:uint;
			if( object is Mesh ) {
				var mesh:Mesh = object as Mesh;
				_meshCollection.push( mesh );
				for( i = 0, len = mesh.numChildren; i < len; ++i ) {
					collectMesh( mesh.getChildAt( i ) );
				}
			}

			if( object is ObjectContainer3D || object is Entity ) {
				var asContainer:ObjectContainer3D = object as ObjectContainer3D;
				for( i = 0, len = asContainer.numChildren; i < len; ++i ) {
					collectMesh( mesh.getChildAt( i ) );
				}
			}
		}
	}
}
