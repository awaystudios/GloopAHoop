package com.awaystudios.gloopahoop.events
{
	import flash.events.Event;

	public class WrapperEvent extends Event
	{
		public static const WRAPPER_DONE : String = 'wrapperDone';
		
		public function WrapperEvent(type : String)
		{
			super(type);
		}
		
		
		public override function clone() : Event
		{
			return new WrapperEvent(type);
		}
	}
}