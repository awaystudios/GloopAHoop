package com.awaystudios.gloopahoop.input
{

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import wck.BodyShape;

	public class PhysicsMouseEvent extends MouseEvent
	{
		public static const PHYSICS_MOUSE_EVENT:String = "physics-mouse-event";

		public var displayObject:DisplayObject;
		public var body:BodyShape;

		public function PhysicsMouseEvent( type:String, bubbles:Boolean = true, cancelable:Boolean = false, localX:Number = 0, localY:Number = 0, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:Number = 0 ) {
			super( type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta );
		}

		override public function clone():Event {
			return new PhysicsMouseEvent( type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta );
		}
	}
}