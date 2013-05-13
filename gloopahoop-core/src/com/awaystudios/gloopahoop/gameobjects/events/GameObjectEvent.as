package com.awaystudios.gloopahoop.gameobjects.events
{
	import com.awaystudios.gloopahoop.gameobjects.*;
	
	import flash.events.*;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GameObjectEvent extends Event {
		
		public static const LAUNCHER_CATCH_GLOOP:String = "gameobjectevent_launcher_catch_gloop";
		public static const LAUNCHER_FIRE_GLOOP	:String = "gameobjectevent_launcher_fire";
		
		public static const GLOOP_HIT_GOAL_WALL	:String = "gameobjectevent_gloop_hit_goal_wall";
		public static const GLOOP_APPROACH_GOAL_WALL :String = "gameobjectevent_gloop_approach_goal_wall";
		public static const GLOOP_MISSED_GOAL_WALL : String = "gameobjectevent_gloop_missed_goal_wall";
		public static const GLOOP_LOST_MOMENTUM	:String = "gameobjectevent_gloop_lost_momentum";
		public static const GLOOP_FIRED	:String = "gameobjectevent_gloop_fired";

		public static const GLOOP_COLLECT_STAR  :String = "gameobjectevent_gloop_collect_star";
		
		public static const HOOP_REMOVE		  :String = "gameobjectevent_hoop_remove";
		
		private var _gameObject:DefaultGameObject;
		
		public function GameObjectEvent(type:String, gameObject:DefaultGameObject) { 
			super(type, false, false);
			_gameObject = gameObject;
		} 
		
		public override function clone():Event { 
			return new GameObjectEvent(type, gameObject);
		} 
		
		public override function toString():String { 
			return formatToString("GameObjectEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get gameObject():DefaultGameObject {
			return _gameObject;
		}
		
	}
	
}