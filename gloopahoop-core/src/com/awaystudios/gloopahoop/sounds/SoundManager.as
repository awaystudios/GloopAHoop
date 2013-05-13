package com.awaystudios.gloopahoop.sounds
{

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	public class SoundManager
	{
		private static var _sounds:Object;
		private static var _initialized:Boolean;
		private static var _enabled:Boolean = true;

		private static var _mainSoundChannel:SoundChannel;
		private static var _gloopSoundChannel:SoundChannel;
		private static var _fanSoundChannel:SoundChannel;

		public static const CHANNEL_MAIN:String = "mainChannel";
		public static const CHANNEL_GLOOP:String = "gloopChannel";
		public static const CHANNEL_FAN:String = "fanChannel";

		private static var _channels:Object;

		private static var _lastId:String;
		private static var _sameIdCounter:uint;

		private static var _sndRepeatTmr:Timer;

		private static function init():void {
			if( !_initialized ) {
				_mainSoundChannel = new SoundChannel();
				_gloopSoundChannel = new SoundChannel();
				_fanSoundChannel = new SoundChannel();
				_channels = new Object();
				_channels[ CHANNEL_MAIN ] = _mainSoundChannel;
				_channels[ CHANNEL_GLOOP ] = _gloopSoundChannel;
				_channels[ CHANNEL_FAN ] = _fanSoundChannel;
				_initialized = true;
				_sounds = {};
				_sndRepeatTmr = new Timer( 500, 1 ); // Used to avoid too many of the same sound happening too quickly.
				_sndRepeatTmr.addEventListener( TimerEvent.TIMER, onSndRepeatTimer );
			}
		}

		private static function onSndRepeatTimer( event:TimerEvent ):void {
			_sameIdCounter = 0;
		}

		public static function addSound( id:String, sound:Sound ):void {
			init();

			_sounds[id] = sound;
		}

		public static function get enabled():Boolean {
			return _enabled;
		}

		public static function set enabled( value:Boolean ):void {
			_enabled = value;
		}

		private static var _fanPlaying:Boolean;

		public static function stop( channelId:String ):void {
			if( !_channels[ channelId ] ) {
				throw new Error( "Channel id not identified in SoundManager.as: " + channelId );
			}
//			trace( "stopping channel: " + channelId, _channels[ channelId ] );

			if( _fanPlaying && channelId == CHANNEL_FAN ) {
				_fanSoundChannel.stop();
				_fanPlaying = false;
			}
		}

		public static function play( id:String, channelId:String = CHANNEL_MAIN ):void {

			if( !_enabled ) return;

			// Do not allow too many sounds of the same type in a short period of time.
			if( _sameIdCounter > 5 ) {
				return;
			}

			var sound:Sound;
			init();
			if( !_sounds[ id ] ) {
				throw new Error( "Sound id not added to SoundManager.as: " + id );
			}
			sound = _sounds[id];

//			trace( "channel: " + _channels[ channelId ] );
			if( _channels[ channelId ] == null ) {
				throw new Error( "Channel id not identified in SoundManager.as: " + channelId );
//				return;
			}

			// only has 1 voice
			if( channelId == CHANNEL_GLOOP ) {
				_gloopSoundChannel.stop();
			}

			if( _fanPlaying && channelId == CHANNEL_FAN ) {
				return;
			}

			if( channelId == CHANNEL_FAN ) {
				_fanPlaying = true;
				_fanSoundChannel = sound.play( 0, 999 );
				return;
			}

//			trace( "playing sound: " + id );
			_channels[ channelId ] = sound.play();

			if( _lastId == id ) {
				_sameIdCounter++;
				_sndRepeatTmr.reset();
				_sndRepeatTmr.start();
			}
			else {
				_sameIdCounter = 0;
			}

			_lastId = id;
		}

		public static function playWithDelay( id:String, delay:Number, channelId:String = CHANNEL_GLOOP ):void {
			setTimeout( play, uint( delay * 1000 ), id, channelId );
		}

		public static function playRandom( options:Array, channelId:String = CHANNEL_GLOOP ):void {
			var index:uint = Math.floor( options.length * Math.random() );
			play( options[ index ], channelId );
		}

		public static function playRandomWithDelay( options:Array, delay:Number, channelId:String = CHANNEL_GLOOP ):void {
			var index:uint = Math.floor( options.length * Math.random() );
			playWithDelay( options[ index ], delay, channelId );
		}
	}
}