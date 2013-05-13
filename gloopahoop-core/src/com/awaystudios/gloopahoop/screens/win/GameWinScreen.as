package com.awaystudios.gloopahoop.screens.win
{


	import com.away3d.gloop.lib.*;
	import com.awaystudios.gloopahoop.screens.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	public class GameWinScreen extends ScreenBase
	{
		//private var _container:Sprite;
		private var _video:MovieClip;
		private var _textStuff:Sprite;
		private var _stack:ScreenStack;
		private var _videoContainer:Sprite;

		public function GameWinScreen( stack:ScreenStack ) {
			super();
			_stack = stack;
		}

		override protected function initScreen():void {

			//_container = new Sprite();
			//_ctr.addChild( _container );

			_videoContainer = new Sprite();
			_video = new EndVideo();
			_video.stop();
			_videoContainer.addChild( _video );
			_ctr.addChild( _videoContainer );

			stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );

			_textStuff = new GameEndScreen();
			_textStuff.visible = false;
			_ctr.addChild( _textStuff );

			var facebook:Sprite = _textStuff.getChildByName( "facebook" ) as Sprite;
			var twitter:Sprite = _textStuff.getChildByName( "twitter" ) as Sprite;
			var youtube:Sprite = _textStuff.getChildByName( "youtube" ) as Sprite;

			facebook.alpha = 0;
			twitter.alpha = 0;
			youtube.alpha = 0;

			facebook.useHandCursor = facebook.buttonMode = true;
			twitter.useHandCursor = twitter.buttonMode = true;
			youtube.useHandCursor = youtube.buttonMode = true;

			facebook.addEventListener( MouseEvent.MOUSE_UP, onFacebookMouseUp );
			twitter.addEventListener( MouseEvent.MOUSE_UP, onTwitterMouseUp );
			youtube.addEventListener( MouseEvent.MOUSE_UP, onYoutubeMouseUp );
		}

		private function onStageMouseUp( event:MouseEvent ):void {

			if( !_active ) {
				return;
			}

			if( event.target is GameEndScreen ) {
				_stack.gotoScreen( Screens.START );
			}
		}

		private function onYoutubeMouseUp( event:MouseEvent ):void {
			navigateToURL( new URLRequest( "http://www.youtube.com/gloopahoop" ), "_blank" );
		}

		private function onTwitterMouseUp( event:MouseEvent ):void {
			navigateToURL( new URLRequest( "http://www.twitter.com/gloopahoop" ), "_blank" );
		}

		private function onFacebookMouseUp( event:MouseEvent ):void {
			navigateToURL( new URLRequest( "http://www.facebook.com/gloopahoop" ), "_blank" );
		}

		override public function activate():void {

			_active = true;

			_video.gotoAndPlay( 1 );

			super.activate();
		}

		override public function deactivate():void {

			_video.gotoAndStop( 1 );

			_active = false;
			_textStuff.visible = false;

			super.deactivate();
		}

		override protected function update():void {

			if( !_active ) {
				return;
			}

			if( _video.currentFrame == 61 ) {
				_textStuff.visible = true;
			}

			if( _video.currentFrame == 122 ) {
				_video.gotoAndPlay( 63 );
			}
		}
	}
}
