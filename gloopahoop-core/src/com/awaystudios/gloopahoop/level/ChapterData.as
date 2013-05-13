package com.awaystudios.gloopahoop.level
{
	import com.awaystudios.gloopahoop.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	public class ChapterData extends EventDispatcher
	{
		private var _title : String;
		private var _idx:uint;
		private var _posterUrl : String;
		
		private var _posterBitmap : Bitmap;
		
		private var _levels : Vector.<LevelProxy>;
		
		public function ChapterData(idx:uint)
		{
			_idx = idx;
			_levels = new Vector.<LevelProxy>();
		}
		
		
		public function get idx() : uint
		{
			return _idx;
		}		
		
		public function get levels() : Vector.<LevelProxy>
		{
			return _levels;
		}
		
		
		public function get title() : String
		{
			return _title;
		}
		
		
		public function get posterBitmap() : Bitmap
		{
			return _posterBitmap
		}
		
		
		public function loadPoster() : void
		{
			var loader : Loader;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			var postUrl:String = _posterUrl + "?" + GameSettings.GLOOP_VERSION;
			loader.load(new URLRequest(GameSettings.ROB_PATH? "../bin/" + postUrl : postUrl));
		}
		
		
		public function getLevelById(id : int) : LevelProxy
		{
			var i : uint;
			
			for (i=0; i<_levels.length; i++) {
				if (_levels[i].id == id)
					return _levels[i];
			}
			
			return null;
		}
		
		
		public function calcTotalStarsCollected() : uint
		{
			var i : uint;
			var len : uint;
			var stars : uint;
			
			len = _levels.length;
			stars = 0;
			
			for (i=0; i<len; i++) {
				stars += _levels[i].bestStarsCollected;
			}
			
			return stars;
		}
		
		
		public function clearState() : void
		{
			var i : uint;
			
			for (i=0; i<_levels.length; i++) {
				_levels[i].locked = true;
				_levels[i].clearState();
			}
			
			if (_levels.length > 0)
				_levels[0].locked = false;
		}
		
		
		public function parseXml(xml : XML) : void
		{
			var idx : uint;
			var level_xml : XML;
			var prevCompleted : Boolean;
			
			_title = xml.title.toString();
			_posterUrl = xml.@poster.toString();
			
			idx = 0;
			prevCompleted = true;
			
			for each (level_xml in xml.level) {
				var level : LevelProxy;
				
				level = new LevelProxy(idx++);
				level.parseXml(level_xml);
				level.locked = !prevCompleted;
				
				_levels.push(level);
				
				prevCompleted = level.completed;
			}
		}
		
		
		private function onLoaderComplete(ev : Event) : void
		{
			var info : LoaderInfo;
			
			info = LoaderInfo(ev.currentTarget);
			info.removeEventListener(Event.COMPLETE, onLoaderComplete);
			
			_posterBitmap = Bitmap(info.content);
			_posterBitmap.smoothing = true;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}