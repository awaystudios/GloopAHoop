package com.awaystudios.gloopahoop.level
{
	import com.awaystudios.gloopahoop.events.*;
	
	import flash.events.*;
	import flash.net.*;

	public class LevelDatabase extends EventDispatcher
	{
		private var _chapters : Vector.<ChapterData>;
		private var _selectedChapter : ChapterData;
		private var _selectedLevelProxy : LevelProxy;
		
		private var _numChaptersLoading : int;
		
		
		public function LevelDatabase()
		{
			_chapters = new Vector.<ChapterData>();
		}
		
		
		public function get chapters() : Vector.<ChapterData>
		{
			return _chapters;
		}

		public function isSelectedChapterTheLastOne():Boolean {
			return _selectedChapter == _chapters[ _chapters.length - 1 ];
		}
		
		public function get selectedChapter() : ChapterData
		{
			return _selectedChapter;
		}
		
		public function get selectedLevelProxy() : LevelProxy
		{
			return _selectedLevelProxy;
		}
		
		
		public function selectChapter(chapter : ChapterData) : void
		{
			_selectedChapter = chapter;
			dispatchEvent(new GameEvent(GameEvent.CHAPTER_SELECT));
		}
		
		
		public function selectLevel(proxy : LevelProxy) : void
		{
			deselectCurrentLevel();
			
			_selectedLevelProxy = proxy;
			_selectedLevelProxy.addEventListener(GameEvent.LEVEL_LOSE, onSelectedGameEvent);
			_selectedLevelProxy.addEventListener(GameEvent.LEVEL_WIN, onSelectedGameEvent);
			
			dispatchEvent(new GameEvent(GameEvent.LEVEL_SELECT));
		}
		
		
		public function getStateXml() : XML
		{
			var xml : XML;
			var chapter : ChapterData;
			
			xml = new XML('<state><levels/></state>');
			
			for each (chapter in _chapters) {
				var i : uint;
				var len : uint;
				
				len = chapter.levels.length;
				for (i=0; i<len; i++) {
					var level : LevelProxy;
					
					level = chapter.levels[i];
					if (level.completed) {
						xml.levels.appendChild(level.getStateXml());
					}
				}
			}
			
			return xml;
		}
		
		
		public function setStateFromXml(xml : XML) : void
		{
			var level_xml : XML;
			
			for each (level_xml in xml.levels.level) {
				var id : int;
				var level : LevelProxy;
				
				id = parseInt(level_xml.@id.toString());
				level = getLevelById(id);
				if (level)
					level.setStateFromXml(level_xml);
			}
		}
		
		
		public function clearState() : void
		{
			var i : uint;
			
			for (i=0; i<_chapters.length; i++) {
				_chapters[i].clearState();
			}
		}
		
		
		public function loadXml(url : String) : void
		{
			var xml_loader : URLLoader;
			
			xml_loader = new URLLoader();
			xml_loader.addEventListener(Event.COMPLETE, onXmlLoaderComplete);
			xml_loader.load(new URLRequest(url));
		}
		
		
		private function deselectCurrentLevel() : void
		{
			if (_selectedLevelProxy) {
				_selectedLevelProxy.dispose();
				_selectedLevelProxy.removeEventListener(GameEvent.LEVEL_LOSE, onSelectedGameEvent);
				_selectedLevelProxy.removeEventListener(GameEvent.LEVEL_WIN, onSelectedGameEvent);
			}
		}
		
		
		private function getLevelById(id : int) : LevelProxy
		{
			var i : uint;
			
			for (i=0; i<_chapters.length; i++) {
				var level : LevelProxy;
				
				level = _chapters[i].getLevelById(id);
				if (level)
					return level;
			}
			
			return null;
		}
		
		
		private function onSelectedGameEvent(ev : GameEvent) : void
		{
			dispatchEvent(ev.clone());
		}
		
		
		private function onXmlLoaderComplete(ev : Event) : void
		{
			var xml : XML;
			var chapter_xml : XML;
			var level_xml : XML;
			var xml_loader : URLLoader;
			
			xml_loader = URLLoader(ev.currentTarget);
			xml_loader.removeEventListener(Event.COMPLETE, onXmlLoaderComplete);
			xml = new XML(xml_loader.data);
			
			_numChaptersLoading = 0;
			
			for each (chapter_xml in xml.chapter) {
				var chapter : ChapterData;
				
				chapter = new ChapterData(_numChaptersLoading++);
				chapter.parseXml(chapter_xml);
				chapter.addEventListener(Event.COMPLETE, onChapterComplete);
				chapter.loadPoster();
				
				_chapters.push(chapter);
			}
			
			tryFinishLoad();
		}
		
		
		private function tryFinishLoad() : void
		{
			if (_numChaptersLoading==0) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		
		private function onChapterComplete(ev : Event) : void
		{
			var chapter : ChapterData;
			
			chapter = ChapterData(ev.currentTarget);
			chapter.removeEventListener(Event.COMPLETE, onChapterComplete);
				
			_numChaptersLoading--;
			tryFinishLoad();
		}
	}
}