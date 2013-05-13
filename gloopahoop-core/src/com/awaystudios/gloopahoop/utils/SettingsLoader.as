package com.awaystudios.gloopahoop.utils
{
	import com.awaystudios.gloopahoop.*;
	import com.junkbyte.console.Cc;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.describeType;

	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
		
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "error", type = "flash.events.ErrorEvent")]
	
	public class SettingsLoader extends EventDispatcher {
		
		private var _loader		:URLLoader;
		private var _data		:String = "";
		private var _targetClass:Class;
		private static const REGEX:RegExp = /^(?<!#)(\w+)\s+(.*?)\s*(#.*)?$/gm;
		
		public function SettingsLoader(targetClass:Class) {
			_targetClass = targetClass;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handleLoadComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			reload();
		}
		
		public function reload():void {
			_loader.load(new URLRequest( ( GameSettings.ROB_PATH? "../bin/assets/settings.dat?" : "assets/settings.dat?" ) + GameSettings.GLOOP_VERSION ) );
		}
		
		private function handleSecurityError(e:SecurityErrorEvent):void {
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "security error loading settings: " + e.text));
		}
		
		private function handleIOError(e:IOErrorEvent):void {
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "io error loading settings: " + e.text));
		}

		private function handleLoadComplete(e:Event):void {			
			_data = _loader.data;
			
			var result:*;
			while (result = REGEX.exec(_data)) {
				if (result[2]=='true') result[2] = true;
				else if (result[2]=='false') result[2] = false;
				
				_targetClass[result[1]] = result[2];
			}
			
			Cc.log("Settings loaded");
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get isComplete():Boolean {
			return _data != "";
		}
				
		public function dump():void {
			var typeXML:XML = describeType(_targetClass);
			
			var varlist:Array = [];
			var maxlen:int = 0;
			var data:Object;
			
			for each (var variable:XML in typeXML.variable) {
				data = { };
				
				for each (var comment:XML in variable.metadata.(@name == "comment")) {
					data.comment = comment.arg.@value;
				}
				
				data.name = variable.@name.toString();
				data.value = _targetClass[variable.@name];
				
				if (data.name.length > maxlen) maxlen = data.name.length;
				
				varlist.push(data);
			}
			
			varlist.sortOn("name");
			
			var lastGroup:String = varlist[0].name.split("_")[0];
			for each (data in varlist) {
				var spaces:String = "";
				for (var i:int = 0; i <= maxlen - data.name.length; i++) spaces += " ";
				
				var output:String = data.name + spaces + data.value;
				if (data.comment) output += "    # " + data.comment;
				
				var group:String = data.name.split("_")[0];
				if (group != lastGroup) trace("");
				lastGroup = group;
				
				Cc.log(output);
			}
		}
		
	}

}