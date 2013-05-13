package com.awaystudios.gloopahoop.gameobjects
{
	import com.awaystudios.gloopahoop.gameobjects.components.*;

	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public interface IMouseInteractive {
		
		function get physics():PhysicsComponent;
		
		function onClick(mouseX:Number, mouseY:Number):void;
		function onDragStart(mouseX:Number, mouseY:Number):void;
		function onDragUpdate(mouseX:Number, mouseY:Number):void;
		function onDragEnd(mouseX:Number, mouseY:Number):void;
		function get draggable():Boolean;
		function get rotatable():Boolean;
	}

}