package com.awaystudios.gloopahoop.utils
{

	import com.junkbyte.console.*;
	
	import away3d.events.*;
	import away3d.library.*;
	import away3d.loaders.misc.*;
	import away3d.loaders.parsers.*;
	
	import flash.events.*;
	
	public class AssetLoaderQueue extends EventDispatcher
	{
		private var _resources : Vector.<Resource>;
		private var _nextResIdx : uint;
		private var _context:AssetLoaderContext = new AssetLoaderContext(false);
		public function AssetLoaderQueue()
		{
			super();
			
			_resources = new Vector.<Resource>();
		}
		
		
		public function addResource(cls : Class, parser:ParserBase) : void
		{
			_resources.push(new Resource(new cls(), parser));
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
				var resource:Resource = _resources[_nextResIdx++];
				AssetLibrary.loadData(resource.data, _context, null, resource.parser);
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



import away3d.loaders.parsers.*;

import flash.utils.*;

internal class Resource
{
	public var data:ByteArray;
	public var parser:ParserBase;
	
	public function Resource(data:ByteArray, parser:ParserBase)
	{
		this.data = data;
		this.parser = parser;
	}
}