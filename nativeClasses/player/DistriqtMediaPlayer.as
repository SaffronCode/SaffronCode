package nativeClasses.player
{
	//import com.distriqt.extension.mediaplayer.MediaPlayer;
	
	//import contents.alert.Alert;
	
	//import com.distriqt.extension.mediaplayer.MediaPlayerOptions;
	import darkBox.DarkBox;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import contents.alert.Alert;
	
	public class DistriqtMediaPlayer extends Sprite
	{
		private var isFullScreen:Boolean = false;
		
		/**com.distriqt.extension.mediaplayer.MediaPlayer*/
		private static var MediaPlayerClass:Class;
		/**com.distriqt.extension.mediaplayer.MediaPlayerOptions*/
		private static var MediaPlayerOptionsClass:Object;
		
		/**com.distriqt.extension.mediaplayer.events.MediaPlayerEvent<br/><br/>
		 * FULLSCREEN_ENTER<br/>
		 * FULLSCREEN_EXIT<br/>
		 * CLICK<br/>
		 * COMPLETE<br/>
		 * ERROR<br/>
		 * LOADED<br/>
		 * LOADING<br/>
		 * PAUSED<br/>
		 * PLAYING<br/>
		 * PROGRESS<br/>
		 * READY<br/>
		 * SEEKING<br/>
		 * STOPPED<br/>
		 * */
		private static var MediaPlayerEventClass:Class;
		
		private static var myDistriqtId:String;
		
		public static var isSupports:Boolean = false;
		
		private static var scl:Number = 0, lastStageW:Number = 0, deltaX:Number, deltaY:Number;
		
		private static var appStageWidth:Number, appStageHeight:Number;
		
		private var isOpen:Boolean = false;
		private var debugIntervalId:uint;
		
		private var lastDeviceOriention:String, lastStageorientetion:String, lastPortrateOrientetion:String = StageOrientation.DEFAULT, lastLandscapeOrientation:String = StageOrientation.ROTATED_RIGHT;
		
		private var player:Object;
		private var manualFullscreen:Boolean, dynamicFullscreen:Boolean;
		
		private var videoQualities:Array = [];
		
		public static var checkBandWidth:Boolean = true;
		private var bt:BandwidthTester;
		private var nc:NetConnection;
		private var stream:NetStream;
		private var videoURL:String;
		private var position:Number = 0;
		private var index:int = 0;
		private var changeIndex:Boolean = true;
		private var lastIndex:int;
		private var playFirstVideo:Boolean = true;
		private var checkQuailyID:int;
		private var checkSeekID:int;
		
		public function DistriqtMediaPlayer(Width:Number, Height:Number)
		{
			super();
			
			if (!isSupports)
			{
				trace("Distriqt media player is not supporting this device");
			}
			isFullScreen = false;
			this.graphics.beginFill(0x222222, 0);
			this.graphics.drawRect(0, 0, Width, Height);
			/*if(isNaN(appStageWidth))
			   {*/
			if (this.stage != null)
			{
				saveStageWidthHeighOnce();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, saveStageWidthHeighOnce);
			}
			//}
		
		}
		
		/**Save the stage widh and height once*/
		private function saveStageWidthHeighOnce(e:* = null):void
		{
			appStageWidth = stage.stageWidth;
			appStageHeight = stage.stageHeight;
			trace("DevicePrefrence.isPortrait() : " + DevicePrefrence.isPortrait());
			if (DevicePrefrence.isPortrait())
			{
				debugIntervalId = setInterval(controlOrientationPortrate, 500);
			}
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, applicationActivated);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, applicationDeactivated);
		}
		
		protected function applicationDeactivated(event:Event):void
		{
			if (player != null)
			{
				try
				{
					player.pause();
				}
				catch (e)
				{
				}
				;
			}
		}
		
		protected function applicationActivated(event:Event):void
		{
			if (player != null)
			{
				try
				{
					player.play();
				}
				catch (e)
				{
				}
				;
			}
		}
		
		private function controlOrientationPortrate()
		{
			if (stage.deviceOrientation == StageOrientation.UNKNOWN || (lastDeviceOriention == stage.deviceOrientation && lastStageorientetion == stage.orientation && (isLandScape(stage.orientation) != isLandScape(stage.deviceOrientation))))
				return;
			
			if (stage.deviceOrientation == StageOrientation.UPSIDE_DOWN || stage.deviceOrientation == StageOrientation.DEFAULT)
				lastPortrateOrientetion = stage.deviceOrientation;
			else
				lastLandscapeOrientation = stage.deviceOrientation;
			
			trace("lastPortrateOrientetion : " + lastPortrateOrientetion);
			trace("lastLandscapeOrientation : " + lastLandscapeOrientation);
			
			trace(" stage.orientation : " + stage.orientation + " vs " + stage.deviceOrientation);
			
			try
			{
				trace("listen to rotation: isFullScreen : " + isFullScreen);
				if (isFullScreen)
				{
					if (stage.deviceOrientation == StageOrientation.DEFAULT || stage.deviceOrientation == StageOrientation.UPSIDE_DOWN)
					{
						trace("Make it exit from full screen : " + player);
						//Make it exit from full screen ;
						//player.setFullscreen( false );
						//isFullScreen = false ;
						if (manualFullscreen == false)
							player.setFullscreen(false);
					}
					else if (isLandScape(stage.orientation))// if(stage.orientation != revertLandScape(stage.deviceOrientation))
					{
						trace("Need to rotate to : " + stage.deviceOrientation);
						stage.setOrientation(revertLandScape(stage.deviceOrientation));
					}
				}
				else
				{
					if (stage.deviceOrientation == StageOrientation.ROTATED_RIGHT || stage.deviceOrientation == StageOrientation.ROTATED_LEFT)
					{
						//Enter full screen
						trace("Make it full screen : " + player);
						//player.setFullscreen( true );
						//isFullScreen = true ;
						dynamicFullscreen = true;
						player.setFullscreen(true);
					}
				}
			}
			catch (e:Error)
			{
				trace("!!!!! Something happend: " + e.message);
			}
			
			lastStageorientetion = stage.orientation;
			lastDeviceOriention = stage.deviceOrientation;
		}
		
		/**Pass the video native path for local files
		 * <br><br>MediaPlayer.CONTROLS_BASIC : controls:basic
		   MediaPlayer.CONTROLS_EMBEDDED : controls:embedded
		   MediaPlayer.CONTROLS_FULLSCREEN : controls:fullscreen
		   MediaPlayer.CONTROLS_NONE : controls:none*/
		public function playVideo(videoURL:String, autoPlay:Boolean = true, controlls:String = "controls:fullscreen"):void
		{
			this.videoURL = videoURL;
			videoQualities = videoURL.split('|');
			if (this.stage == null)
			{
				throw "Add the player to the stage first";
			}
			
			var rect:Rectangle = createVewPort();
			
			close();
			
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			isOpen = true;
			player = (MediaPlayerClass as Object).service.createPlayerView(new MediaPlayerOptionsClass().setViewport(rect).setAutoPlay(true).showControls(true).enableBackgroundAudio(false));
			if (checkBandWidth == true && videoQualities.length>1)
			{
				bt = new BandwidthTester(0, videoQualities[index]);
				bt.addEventListener(BandwidthTester.BAND_TESTED, play_video);
				bt.addEventListener(BandwidthTester.TEST, band_test);
				bt.start();
			}
			else
			{
				
				if (videoURL.indexOf('http') != 0)
				{
					videoURL = new File(videoURL).nativePath;
				}
				else
				{
					if (!DevicePrefrence.isTablet && videoQualities.length > 1)
					{
						videoURL = videoQualities[1];
					}
					else
					{
						videoURL = videoQualities[0];
					}
				}
				player.load(videoURL);
			}
			//player = player.createPlayer(	videoURL,rect.x,rect.y,rect.width,rect.height,autoPlay,controlls,true);
			
			//player = player.createPlayerView(new (MediaPlayerOptions as Object)().setViewport(new Rectangle( rect.x, rect.x, rect.width, rect.height)));
			//var options:MediaPlayerOptions = new MediaPlayerOptions()
			//setAutoPlay( true );
			
			player.addEventListener(MediaPlayerEventClass.FULLSCREEN_ENTER, isFullscreened);
			player.addEventListener(MediaPlayerEventClass.FULLSCREEN_EXIT, exitFullscreened);
			player.addEventListener(MediaPlayerEventClass.LOADING, isLoading);
			player.addEventListener(MediaPlayerEventClass.READY, isReady);
			//player.addEventListener(MediaPlayerEventClass.LOADED, isPlaying);
			//player.addEventListener(MediaPlayerEventClass.CLICK, isPlaying);
			//player.addEventListener(com.distriqt.extension.mediaplayer.events.MediaPlayerEvent.STOPPED,exitFullscreened);
			this.removeEventListener(Event.ENTER_FRAME, controlPlayerViewPort);
			this.addEventListener(Event.ENTER_FRAME, controlPlayerViewPort);
			this.addEventListener(Event.REMOVED_FROM_STAGE, unLoad);
		}
		
		private function band_test(e):void
		{
			trace("testSpeed:" + e.target.last_speed() + ' kb/s')
		}
		
		private function play_video(e):void
		{
			var bw = e.target.getBandwidth();
			
			trace("Final bandwidth: " + bw + ' kb/s');
			trace("Peak bandwidth: " + e.target.getPeak() + ' kb/s');
			lastIndex = index;
			if (bw > 400)
			{
				index = 0;
			}
			else if (bw > 128)
			{
				index = 1;
			}
			else
			{
				index = 2;
			}
			
			if (lastIndex != index)
			{
				changeIndex = true;
			}
			else
			{
				changeIndex = false;
			}
			
			videoURL = videoQualities[index];
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, nc_status);
			nc.connect(null);
		}
		
		private function nc_status(e:NetStatusEvent):void
		{
			switch (e.info.code)
			{
			case "NetConnection.Connect.Success": 
				connect_stream();
				break;
			case "NetStream.Play.StreamNotFound": 
				trace('Could not find video.');
				break;
			}
		}
		
		private function connect_stream():void
		{
			stream = new NetStream(nc);
			stream.addEventListener(NetStatusEvent.NET_STATUS, nc_status);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function(e)
			{
			});
			if (playFirstVideo == true) // play for first time
			{
				player.load(videoURL);
				playFirstVideo = false;
			}
			else
			{
				if (changeIndex == true)// if video quaily change
				{
					position = player.position;
					player.load(videoURL);
				}
			}
			checkQuailyID = setTimeout(checkQuaily, 10000);
		}
		
		private function checkQuaily():void
		{
			bt = new BandwidthTester(0, videoQualities[index]);
			bt.addEventListener(BandwidthTester.BAND_TESTED, play_video);
			bt.addEventListener(BandwidthTester.TEST, band_test);
			bt.start();
		
		}
		
		public function loadVideoWithQuality(degree:int):void
		{
			position = player.position;
			index = degree;
			
			if (degree != 0)
			{
				videoURL = videoQualities[degree-1];
				player.load(videoURL);
			}
			else
			{
				bt = new BandwidthTester(0, videoQualities[index]);
				bt.addEventListener(BandwidthTester.BAND_TESTED, play_video);
				bt.addEventListener(BandwidthTester.TEST, band_test);
				bt.start();
			}
		}
		
		/**Is ready*/
		private function isReady(e:* = null):void
		{
			checkSeekID = setTimeout(seekPlayer, 1000);
		}
		
		private function seekPlayer(e:* = null):void
		{
			//var seekSuccess:Boolean = player.seek(position);
			//player.play();
			player.seek(position);
		}
		
		/**Is loading*/
		private function isLoading(e:*):void
		{
			trace("*** *** ***** isLoading 1 : " + isLoading);
		}
		
		/**Is Loaded*/
		private function isLoaded(e:*):void
		{
			trace("*** *** ***** isLoaded 2 : " + isLoaded);
		
		}
		
		/**is exited from full screen*/
		protected function exitFullscreened(event:Event):void
		{
			manualFullscreen = false;
			dynamicFullscreen = false;
			trace("*** Exit full screen !! : " + event);
			if (/*isFullScreen && */DevicePrefrence.isPortrait())
			{
				stage.setOrientation(lastPortrateOrientetion);
				trace("StageOrientation1. >>> " + lastPortrateOrientetion);
			}
			isFullScreen = false;
		}
		
		/**is full screen now*/
		protected function isFullscreened(event:Event):void
		{
			trace("*** Set full screen !! : " + event);
			if (/*!isFullScreen && */DevicePrefrence.isPortrait() && isFullScreen != true)
			{
				if (!DevicePrefrence.isIOS())
				{
					var toLanscapeOrientation:String = revertLandScape(lastLandscapeOrientation);
					stage.setOrientation(toLanscapeOrientation);
				}
				trace("StageOrientation2. >>> " + toLanscapeOrientation);
				if (!dynamicFullscreen)
					manualFullscreen = true;
			}
			isFullScreen = true;
		}
		
		private function revertLandScape(current:String):String
		{
			switch (current)
			{
			case StageOrientation.ROTATED_LEFT: 
				return StageOrientation.ROTATED_RIGHT;
			default: 
				return StageOrientation.ROTATED_LEFT;
			}
		}
		
		private function isLandScape(current:String):Boolean
		{
			switch (current)
			{
			case StageOrientation.ROTATED_LEFT: 
				return true;
			case StageOrientation.ROTATED_RIGHT: 
				return true;
			}
			return false;
		}
		
		private function createVewPort():Rectangle
		{
			var rect:Rectangle = this.getBounds(stage);
			/*trace("|rect : "+rect);
			
			   trace("stage.fullScreenHeight : "+stage.fullScreenHeight);
			   trace("stage.fullScreenWidth : "+stage.fullScreenWidth);
			   trace("stage.stageHeight : "+stage.stageHeight);
			   trace("stage.stageWidth : "+stage.stageWidth);
			   trace("appStageWidth : "+appStageWidth);
			   trace("appStageHeight : "+appStageHeight);*/
			
			if (scl == 0 || lastStageW != stage.fullScreenWidth)
			{
				lastStageW = stage.fullScreenWidth;
				
				var sclX:Number = (stage.fullScreenWidth / appStageWidth);
				var sclY:Number = (stage.fullScreenHeight / appStageHeight);
				
				deltaX = 0;
				deltaY = 0;
				if (sclX <= sclY)
				{
					scl = sclX;
					deltaY = stage.fullScreenHeight - (appStageHeight) * scl;
				}
				else
				{
					scl = sclY;
					deltaX = stage.fullScreenWidth - (appStageWidth) * scl;
				}
			}
			
			/*trace("scl : "+scl);
			   trace("deltaY : "+deltaY);
			   trace("deltaX : "+deltaX);*/
			
			rect.x *= scl;
			rect.y *= scl;
			rect.x += deltaX / 2;
			rect.y += deltaY / 2;
			rect.y-=30;
			rect.width *= scl;
			rect.height *= scl;
			
			rect.x = round(rect.x);
			rect.y = round(rect.y);
			rect.width = round(rect.width);
			rect.height = round(rect.height);
			
			return rect;
		}
		
		/**Close player*/
		public function close():void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			trace("Hide the player");
			clearTimeout(checkSeekID);
					clearTimeout(checkQuailyID);
			try
			{
				player.removeEventListener(MediaPlayerEventClass.FULLSCREEN_ENTER, isFullscreened);
				player.removeEventListener(MediaPlayerEventClass.FULLSCREEN_EXIT, exitFullscreened);
				exitFullscreened(null);
				isOpen = false;
				player.destroy();
				player = null;
			}
			catch (e)
			{
			}
			;
			this.removeEventListener(Event.ENTER_FRAME, controlPlayerViewPort);
		}
		
		protected function unLoad(event:Event):void
		{
			clearInterval(debugIntervalId);
			clearTimeout(checkSeekID);
					clearTimeout(checkQuailyID);
			//Alert.show("NORMALunLoad");
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			if (player != null)
			{
				try
				{
					player.removeEventListener(MediaPlayerEventClass.FULLSCREEN_ENTER, isFullscreened);
					player.removeEventListener(MediaPlayerEventClass.FULLSCREEN_EXIT, exitFullscreened);
					exitFullscreened(null);
					trace("Remove player");
					//player.removeEventListener(com.distriqt.extension.mediaplayer.events.MediaPlayerEvent.STOPPED,exitFullscreened);
					player.destroy();
					player = null;
					
					
				}
				catch (e)
				{
					trace(">>e" + e);
				}
			}
			this.removeEventListener(Event.ENTER_FRAME, controlPlayerViewPort);
			
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, applicationActivated);
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, applicationDeactivated);
		}
		
		/**Controll the player place*/
		protected function controlPlayerViewPort(event:Event = null):void
		{
			if (isFullScreen || !isOpen)
			{
				return;
			}
			if (Obj.isAccesibleByMouse(this))
			{
				var rect:Rectangle = createVewPort();
				player.resize(rect.x, rect.y, rect.width, rect.height);
			}
			else
			{
				player.resize(0, 0, 0, 0);
			}
		}
		
		private function round(num:Number):Number
		{
			return Math.round(num);
		}
		
		/**Add the natives below : <ber>
		 *
		   <extensionID>com.distriqt.Core</extensionID>
		   <extensionID>com.distriqt.MediaPlayer</extensionID>*/
		public static function setId(distriqtId:String=null):void
		{
			myDistriqtId = distriqtId;
			trace("++++Distriqt media player starts+++");
			try
			{
				MediaPlayerClass = getDefinitionByName("com.distriqt.extension.mediaplayer.MediaPlayer") as Class;
				MediaPlayerOptionsClass = getDefinitionByName("com.distriqt.extension.mediaplayer.MediaPlayerOptions") as Class;
				MediaPlayerEventClass = getDefinitionByName("com.distriqt.extension.mediaplayer.events.MediaPlayerEvent") as Class;
				trace("+++Media player starts+++");
			}
			catch (e)
			{
				MediaPlayerClass = null;
				MediaPlayerOptionsClass = null;
				MediaPlayerEventClass = null;
				isSupports = false;
				trace('*********************** You dont have com.distriqt.extension.mediaplayer.MediaPlayer embeded in your project **************************');
				return;
			}
			try
			{
				//(MediaPlayerClass as Object).init(myDistriqtId);
				if ((MediaPlayerClass as Object).isSupported)
				{
					isSupports = true;
					trace("+++Media player is supports+++");
				}
				else
				{
					trace("+++media player is not supports+++");
				}
			}
			catch (e:Error)
			{
				trace("+++Distriqt media player isSupports : " + e);
				isSupports = false;
			}
		}
	}
}