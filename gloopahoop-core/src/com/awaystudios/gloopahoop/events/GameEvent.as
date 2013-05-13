package com.awaystudios.gloopahoop.events
{
	import flash.events.Event;

	public class GameEvent extends Event
	{
		public static const GAME_PAUSE : String = 'gamePause';
		public static const GAME_RESUME : String = 'gameResume';
		
		public static const GAME_WIN : String = 'gameWin';
		public static const LEVEL_WIN : String = 'levelWin';
		public static const LEVEL_LOSE : String = 'levelLose';
		public static const LEVEL_LOAD : String = 'levelLoad';
		public static const LEVEL_SELECT : String = 'levelSelect';
		public static const LEVEL_RESET : String = 'levelReset';
		public static const LEVEL_STAR_COLLECT : String = 'levelStarCollect';
		public static const CHAPTER_SELECT : String = 'chapterSelect';
		
		public function GameEvent(type : String)
		{
			super(type);
		}
		
		
		public override function clone() : Event
		{
			return new GameEvent(type);
		}
	}
}