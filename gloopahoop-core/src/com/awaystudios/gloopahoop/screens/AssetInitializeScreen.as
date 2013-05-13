package com.awaystudios.gloopahoop.screens
{

	import away3d.containers.View3D;

	import flash.events.Event;

	public class AssetInitializeScreen extends ScreenBase
	{
		private var _view:View3D;

		public function AssetInitializeScreen( view:View3D ) {
			super();
			_view = view;
		}

		protected override function initScreen():void {
			background.visible = false;
		}

		public override function activate():void {
			super.activate();

			AssetManager.instance.view = _view;
			AssetManager.instance.initializeAnimations();
			AssetManager.instance.addEventListener( Event.COMPLETE, onAnimationsInitialized );
		}

		private function onAnimationsInitialized( event:Event ):void {
			dispatchEvent( event );
		}
	}
}
