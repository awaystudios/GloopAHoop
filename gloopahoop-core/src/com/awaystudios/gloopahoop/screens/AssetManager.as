package com.awaystudios.gloopahoop.screens
{

	import com.awaystudios.gloopahoop.gameobjects.components.*;
	import com.awaystudios.gloopahoop.utils.*;
	
	import away3d.animators.*;
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.entities.*;
	import away3d.library.*;
	import away3d.lights.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.textures.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	/*
	* AssetManager has 2 functions.
	* 1) Act as a centralized Singleton to retrieve 3D assets.
	* 2) Animate on screen ( even though the screen could be hidden under 2D content ) any heavy resources, to ensure that complex asset initialization
	* does not happen during game play for the 1st time, something that could represent a fps hiccup.
	* */
	public class AssetManager extends EventDispatcher
	{
		private static var _instance:AssetManager;

		private var _view:View3D;
		private var _scene:Scene3D;
		private var _tempLight:PointLight;
		private var _tempLightPicker:StaticLightPicker;

		public var gloopSplatAnimMesh:Mesh;
		public var gloopStdAnimMesh:Mesh;
		public var gloopSplatAnimation:VertexAnimationComponent;
		public var gloopStdAnimation:VertexAnimationComponent;

		public var cannonMesh:Mesh;
		public var cannonBody:Mesh;
		public var cannonFrame0:Geometry;
		public var cannonFrame1:Geometry;
		public var animator:VertexAnimator;
		public var cannonAnimation:VertexAnimationComponent;

		public function AssetManager() {
		}

		public function initializeAnimations():void {

			_scene = new Scene3D();
			_view.scene = _scene;
			_view.camera.position = new Vector3D( -500, 500, 0 );
			_view.camera.lookAt( new Vector3D() );

			_tempLight = new PointLight();
			_tempLight.specular = 0;
			_tempLight.ambient = 0.4;
			_tempLightPicker = new StaticLightPicker( [ _tempLight ] );

			addEventListener( Event.ENTER_FRAME, enterframeHandler );

			initializeGloopFly();
			initializeGloopSplat();
			initializeCannonVisual();
			initializeCannonAnimation();
			doComplete();

		}

		private function initializeCannonVisual():void {
			var tex : BitmapTexture;
			var bodyMat:TextureMaterial;
			var footMat:TextureMaterial;
			var footGeom:Geometry;
			var bodyGeom:Geometry;

			tex = new BitmapTexture( Bitmap( new EmbeddedResources.CannonDiffusePNGAsset() ).bitmapData );

			bodyMat = new TextureMaterial( tex );
			footMat = new TextureMaterial( tex );

			bodyMat.lightPicker = _tempLightPicker;
			footMat.lightPicker = _tempLightPicker;

			bodyGeom = Geometry( AssetLibrary.getAsset( 'CannonFrame0_geom' ) ).clone();
			bodyGeom.scale(100);
			Geometry(AssetLibrary.getAsset('CannonFrame0_geom')).scale(100);
			Geometry(AssetLibrary.getAsset('CannonFrame1_geom')).scale(100);
			Geometry(AssetLibrary.getAsset('CannonFrame2_geom')).scale(100);
			Geometry(AssetLibrary.getAsset('CannonFrame3_geom')).scale(100);
			
			footGeom = Geometry( AssetLibrary.getAsset( 'CannonFoot_geom' ) );
			footGeom.scale(100);
			cannonMesh = new Mesh( footGeom, footMat );
			cannonMesh.z = 150;
			cannonBody = new Mesh( bodyGeom, bodyMat );
		}

		private function initializeCannonAnimation():void {
			cannonFrame0 = Geometry(AssetLibrary.getAsset('CannonFrame0_geom'));
			cannonFrame1 = Geometry(AssetLibrary.getAsset('CannonFrame1_geom'));

			cannonAnimation = new VertexAnimationComponent(cannonBody);
			
			cannonAnimation.addClip('aim', [
				cannonFrame0,
				cannonFrame1
			], 1000, false);
			
			
			cannonAnimation.addClip('fire', [
				cannonFrame1,
				Geometry(AssetLibrary.getAsset('CannonFrame2_geom')),
				Geometry(AssetLibrary.getAsset('CannonFrame3_geom')),
				Geometry(AssetLibrary.getAsset('CannonFrame0_geom'))
			], 50, false);

			animator = cannonBody.animator as VertexAnimator;

			_scene.addChild( cannonBody );
			cannonAnimation.play( 'fire', 0 );
		}

		public var smileMat:TextureMaterial;
		public var sadMat:TextureMaterial;
		public var ouchMat:TextureMaterial;
		public var yippeeMat:TextureMaterial;
		private function initializeGloopFly():void {
			var smile_grin_tex : BitmapTexture;
			var sad_tex : BitmapTexture;
			var ouch_tex : BitmapTexture;
			var yippee_tex : BitmapTexture;
			var geom:Geometry;

			smile_grin_tex = new BitmapTexture(Bitmap(new EmbeddedResources.GloopDiffuseSmileGrin).bitmapData);
			sad_tex = new BitmapTexture(Bitmap(new EmbeddedResources.GloopDiffuseSad).bitmapData);
			ouch_tex = new BitmapTexture(Bitmap(new EmbeddedResources.GloopDiffuseOuch).bitmapData);
			yippee_tex = new BitmapTexture(Bitmap(new EmbeddedResources.GloopDiffuseYippee).bitmapData);

			smileMat = new TextureMaterial(smile_grin_tex);
			sadMat = new TextureMaterial(sad_tex);
			ouchMat = new TextureMaterial(ouch_tex);
			yippeeMat = new TextureMaterial(yippee_tex);

			smileMat.lightPicker = _tempLightPicker;
			sadMat.lightPicker = _tempLightPicker;
			ouchMat.lightPicker = _tempLightPicker;
			yippeeMat.lightPicker = _tempLightPicker;

			geom = Geometry( AssetLibrary.getAsset( 'GloopFlyFrame0Geom' ) );

			gloopStdAnimMesh = new Mesh( geom, smileMat );
//			gloopStdAnimMesh.subMeshes[0].scaleU = 0.5;
//			gloopStdAnimMesh.subMeshes[0].scaleV = 0.5;
//			gloopStdAnimMesh.z = -150; // do not leave gloop mesh offsets uncommented

//			smileMat.repeat = true;
//			sadMat.repeat = true;
//			ouchMat.repeat = true;
//			yippeeMat.repeat = true;

			/*setInterval(function() : void {
				gloopStdAnimMesh.subMeshes[0].offsetU = (gloopStdAnimMesh.subMeshes[0].offsetU)? 0 : 0.5;
			}, 300);*/

			gloopStdAnimation = new VertexAnimationComponent( gloopStdAnimMesh );
			gloopStdAnimation.addClip( 'fly', [
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame0Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame1Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame2Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame3Geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GloopFlyFrame4Geom' ) )
			] );

			_scene.addChild( gloopStdAnimMesh );
			gloopStdAnimation.play( 'fly' );
		}

		private function initializeGloopSplat():void {

			var tex:BitmapTexture;
			var geom:Geometry;
			var mat:TextureMaterial;

			tex = new BitmapTexture( Bitmap( new EmbeddedResources.GloopSplatDiffusePNGAsset ).bitmapData );
			mat = new TextureMaterial( tex );
			mat.lightPicker = _tempLightPicker;

			geom = Geometry( AssetLibrary.getAsset( 'GlSplatFr0_geom' ) );

			gloopSplatAnimMesh = new Mesh( geom, mat );
//			gloopSplatAnimMesh.y = -Settings.GLOOP_RADIUS - 10;

			gloopSplatAnimation = new VertexAnimationComponent( gloopSplatAnimMesh );
			gloopSplatAnimation.addClip( 'splat', [
				Geometry( AssetLibrary.getAsset( 'GlSplatFr0_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr1_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr2_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr3_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr4_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr3_geom' ) ),
				Geometry( AssetLibrary.getAsset( 'GlSplatFr4_geom' ) )
			], 100, false );

			_scene.addChild( gloopSplatAnimMesh );
			gloopSplatAnimation.play( 'splat' );
		}

		public static function get instance():AssetManager {
			if( !_instance ) {
				_instance = new AssetManager();
			}
			return _instance;
		}

		private function doComplete():void {
			setTimeout( function():void {

				removeEventListener( Event.ENTER_FRAME, enterframeHandler );
				dispatchEvent( new Event( Event.COMPLETE ) );

			}, 1500 );
		}

		private function enterframeHandler( event:Event ):void {
			_view.render();
		}

		public function get view():View3D {
			return _view;
		}

		public function set view( value:View3D ):void {
			_view = value;
		}
	}
}
