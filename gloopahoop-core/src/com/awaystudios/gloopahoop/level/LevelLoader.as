package com.awaystudios.gloopahoop.level
{
	import com.awaystudios.gloopahoop.*;
	import com.awaystudios.gloopahoop.gameobjects.*;
	import com.awaystudios.gloopahoop.gameobjects.hoops.*;
	
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.pick.*;
	import away3d.entities.*;
	import away3d.events.*;
	import away3d.library.assets.*;
	import away3d.loaders.*;
	import away3d.materials.*;
	import away3d.textures.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;

	public class LevelLoader extends EventDispatcher
	{
		private var _scale : Number;
		private var _level : Level;
		private var _greyMat:TextureMaterial;
		
		public function LevelLoader(scale : Number = 1)
		{
			_scale = scale;
			_greyMat = new TextureMaterial(new BitmapTexture(new BitmapData(512, 512, false, 0x666666)));
		}
		
		
		public function get loadedLevel() : Level
		{
			return _level;
		}
		
		
		public function load(req : URLRequest) : void
		{
			var loader : AssetLoader;
			
			reset();
			
			loader = new AssetLoader();
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			loader.load(req);
		}
		
		
		public function loadData(bytes : ByteArray) : void
		{
			var loader : AssetLoader;
			
			reset();
			
			loader = new AssetLoader();
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			loader.loadData(bytes, '');
		}
		
		
		private function reset() : void
		{
			_level = new Level();
		}

		private function parseWall(obj : ObjectContainer3D) : void
		{
			var mesh : Mesh;
			var wall : Wall;
			var min : Vector3D;
			var dim : Vector3D;
			
			mesh = Mesh(obj);
			min = mesh.bounds.min;
			dim = mesh.bounds.max.subtract(min);
			
			wall = new Wall(min.x, -min.y - dim.y, dim.x, dim.y);
			wall.physics.x = obj.x * _scale;
			wall.physics.y = -obj.y * _scale;
			wall.physics.rotation = -obj.rotationZ;
			
			_level.add(wall);
		}
		
		
		private function parseSpawnPoint(obj : ObjectContainer3D) : void
		{
			_level.spawnPoint.x = obj.x * _scale;
			_level.spawnPoint.y = -obj.y * _scale;
			_level.spawnAngle = parseFloat(obj.extra['gah_spawn_angle']) || 0;
		}
		
		
		private function parseHoop(obj : ObjectContainer3D) : void
		{
			var hoop : Hoop;

			var movable:Boolean = obj.extra['gah_movable'] == "1" ? true : false;
//			var movable:Boolean = true;
			var rotatable:Boolean = obj.extra['gah_rotatable'] == "1" ? true : false;
//			var rotatable:Boolean = true;

			switch (obj.extra['gah_hoop']) {
				case HoopType.TRAMPOLINE:
					hoop = new TrampolineHoop(obj.x * _scale, -obj.y * _scale, -obj.rotationZ, movable, rotatable);
					break;
				
				case HoopType.ROCKET:
					hoop = new RocketHoop(obj.x * _scale, -obj.y * _scale, -obj.rotationZ, movable, rotatable);
					break;
			}
			
			_level.add(hoop);
		}
		
		private function parseBox( obj:ObjectContainer3D ):void {
			var box:Box;
			box = new Box( obj.x * _scale, -obj.y * _scale );
			_level.add( box );
		}
		
		private function parseMonitor( obj:ObjectContainer3D ):void {
			var monitor:Monitor;
			var type:String;
			
			type = obj.extra['gah_monitor'];
			monitor = new Monitor( obj.x * _scale, -obj.y * _scale, obj.z * _scale, obj.rotationY, type );
			_level.add( monitor );
		}

		private function parseStar(obj : ObjectContainer3D) : void
		{
			var star : Star;
			
			star = new Star(obj.x * _scale, -obj.y * _scale);
			_level.add(star);
		}
		
		
		private function parseButton(obj : ObjectContainer3D) : void
		{
			var btn : Button;
			var grp : uint;
			
			grp = parseInt(obj.extra['gah_btn_grp']);
			btn = new Button(obj.x * _scale, -obj.y * _scale, -obj.rotationZ, grp);
			_level.add(btn);
		}
		
		
		private function parseFan(obj : ObjectContainer3D) : void
		{
			var fan : Fan;
			var grp : uint;
			
			grp = parseInt(obj.extra['gah_btn_grp']);
			fan = new Fan(obj.x * _scale, -obj.y * _scale, -obj.rotationZ, grp);
			_level.add(fan);
		}
		
		
		private function parseTarget(obj : ObjectContainer3D) : void
		{
			var target : GoalWall;
			var min : Vector3D;
			var dim : Vector3D;
			var mesh : Mesh;
			
			mesh = Mesh(obj);
			min = mesh.bounds.min;
			dim = mesh.bounds.max.subtract(min);
			
			target = new GoalWall(min.x, -min.y - dim.y, dim.x, dim.y);
			target.physics.x = obj.x * _scale;
			target.physics.y = -obj.y * _scale;
			target.physics.rotation = -obj.rotationZ;
			
			_level.add(target);
		}
		
		
		private function parseBounds(obj : ObjectContainer3D) : void
		{
			var mesh : Mesh;
			
			mesh = Mesh(obj);
			
			_level.bounds.x = mesh.x*_scale + mesh.bounds.min.x;
			_level.bounds.y = mesh.y*_scale + mesh.bounds.min.y;
			_level.bounds.right = mesh.x*_scale + mesh.bounds.max.x;
			_level.bounds.bottom = mesh.y*_scale + mesh.bounds.max.y;
		}
		
		
		
		private function parseSceneGraphObject(obj : ObjectContainer3D) : void
		{
			var visual : Boolean;
			
			if (obj.extra && obj.extra.hasOwnProperty('gah_type')) {
				// Assume non-visual object, might be overrided
				// by concrete types in switch below.
				visual = false;

//				trace( "parsing scene object - type: " + obj.extra['gah_type'] );
				
				switch (obj.extra['gah_type']) {
					
					case GameObjectType.BOX:
						parseBox( obj );
						break;
					
					case GameObjectType.MONITOR:
						parseMonitor( obj );
						break;

					case GameObjectType.WALL:
						parseWall(obj);
						break;
					
					case GameObjectType.SPAWN:
						parseSpawnPoint(obj);
						break;
					
					case GameObjectType.HOOP:
						parseHoop(obj);
						break;
					
					case GameObjectType.STAR:
						parseStar(obj);
						break;
					
					case GameObjectType.BUTTON:
						parseButton(obj);
						break;
					
					case GameObjectType.FAN:
						parseFan(obj);
						break;
					
					case GameObjectType.TARGET:
						parseTarget(obj);
						break;
					
					case 'backwall':
						visual = true;
						parseBounds(obj);
						break;
				}
				
				// Non-visual object or placeholder
				if (obj.parent)
					obj.parent.removeChild(obj);
			}
			else {
				// Definitely visual
				visual = true;
			}
			
			if (visual && GameSettings.SHOW_COSMETIC_MESHES) {
				var mesh : Mesh
				
				obj.x *= _scale;
				obj.y *= _scale;
				obj.z *= _scale;
				
				mesh = obj as Mesh;
				if (mesh) {
					var mat : SinglePassMaterialBase;
					
					//if (Settings.STU_MODE || !mesh.material)
					if (!mesh.material)
						mesh.material = _greyMat;
					
					mat = SinglePassMaterialBase(mesh.material);
					mat.repeat = true;
					mat.specular = 0.3;
					
					mesh.pickingCollider = PickingColliderType.AS3_BEST_HIT;
					
					_level.splattableMeshes.push(mesh);
				}
				
				
				// Visual object, add if not already parented
				if (!obj.parent)
					_level.addStatic(obj);
			}
		}
		
		
		private function onAssetComplete(ev : AssetEvent) : void
		{
			switch (ev.asset.assetType) {
				case AssetType.MESH:
				case AssetType.CONTAINER:
					parseSceneGraphObject( ObjectContainer3D(ev.asset) );
					break;
				
				case AssetType.GEOMETRY:
					Geometry(ev.asset).scale(_scale);
					break;
			}
		}
		
		
		private function onResourceComplete(ev : LoaderEvent) : void
		{
			_level.setup();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}