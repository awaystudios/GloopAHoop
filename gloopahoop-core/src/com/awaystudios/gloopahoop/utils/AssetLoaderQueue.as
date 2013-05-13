package com.awaystudios.gloopahoop.utils
{

	import com.junkbyte.console.*;
	
	import away3d.events.*;
	import away3d.library.*;
	import away3d.loaders.misc.*;
	
	import flash.events.*;
	
	public class AssetLoaderQueue extends EventDispatcher
	{
		private var _resources : Vector.<Class>;
		private var _nextResIdx : uint;
		private var _context:AssetLoaderContext = new AssetLoaderContext(false);
		public function AssetLoaderQueue()
		{
			super();
			
			_resources = new Vector.<Class>();
		}
		
		
		public function addResource(cls : Class) : void
		{
			_resources.push(cls);
		}
		
		
		public function load() : void
		{
			_nextResIdx = 0;
			
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
//			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete); // just for tracing out asset names

			loadNext();
		}

		private function onAssetComplete( event:AssetEvent ):void {
			Cc.log( "loaded resource: " + event.asset.name );
		}
		
		
		private function loadNext() : void
		{
			trace(_nextResIdx);
			if (_nextResIdx < _resources.length) {
				AssetLibrary.loadData(_resources[_nextResIdx++], _context);
			}
			else {
				AssetLibrary.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		
		private function onResourceComplete(ev : LoaderEvent) : void
		{
			loadNext();
		}
	}
}