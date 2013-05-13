package com.awaystudios.gloopahoop.screens.settings
{
	
	import com.awaystudios.gloopahoop.level.*;
	import com.away3d.gloop.lib.buttons.*;
	import com.away3d.gloop.lib.settings.*;
	import com.awaystudios.gloopahoop.screens.*;
	import com.awaystudios.gloopahoop.sounds.*;
	import com.awaystudios.gloopahoop.utils.*;
	
	import flash.events.*;
	
	public class SettingsScreen extends ScreenBase
	{
		private var _db : LevelDatabase;
		private var _stack : ScreenStack;
		private var _stateMgr : SaveStateManager;
		
		private var _aboutBtn : AboutButton;
		private var _clearBtn : ClearStateButton;
		
		private var _soundBtn : ToggleButton;
		private var _musicBtn : ToggleButton;
		
		public function SettingsScreen(db : LevelDatabase, stack : ScreenStack, stateMgr : SaveStateManager)
		{
			super(true, true);
			
			_db = db;
			_stack = stack;
			_stateMgr = stateMgr;
		}
		
		
		protected override function initScreen():void
		{
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
			
			_soundBtn = new ToggleButton(new SoundOnBitmap(), new SoundOffBitmap());
			_soundBtn.x = -100;
			_soundBtn.y = -80;
			_soundBtn.toggledOn = true;
			_soundBtn.addEventListener(Event.CHANGE, onSoundToggleChange);
			_ctr.addChild(_soundBtn);
			
			_musicBtn = new ToggleButton(new MusicOnBitmap(), new MusicOffBitmap());
			_musicBtn.x = 100;
			_musicBtn.y = _soundBtn.y;
			_musicBtn.toggledOn = true;
			_musicBtn.addEventListener(Event.CHANGE, onMusicToggleChange);
			_ctr.addChild(_musicBtn);
			
			_clearBtn = new ClearStateButton();
			_clearBtn.x = -_clearBtn.width/2;
			_clearBtn.y = 0;
			_clearBtn.addEventListener(MouseEvent.CLICK, onClearBtnClick);
			_ctr.addChild(_clearBtn);
			
			/* Add this when necessary
			_aboutBtn = new AboutButton();
			_aboutBtn.x = _w/2 - _aboutBtn.width/2;
			_aboutBtn.y = _clearBtn.y + 140;
			addChild(_aboutBtn);
			*/
		}
		
		
		private function onMusicToggleChange(ev : Event) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			MusicManager.enabled = _musicBtn.toggledOn;
		}
		
		
		private function onSoundToggleChange(ev : Event) : void
		{
			SoundManager.enabled = true;
			SoundManager.play(Sounds.MENU_BUTTON);

			SoundManager.enabled = _soundBtn.toggledOn;
		}
		
		
		private function onClearBtnClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_db.clearState();
			_stateMgr.clearState();
		}
		
		
		private function onBackBtnClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stack.gotoScreen(Screens.START);
		}
	}
}