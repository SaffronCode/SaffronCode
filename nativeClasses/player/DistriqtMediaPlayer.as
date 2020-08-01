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
	import flash.events.MouseEvent;
	import contents.Contents;
	
	public class DistriqtMediaPlayer extends Sprite
	{
		public var isFullScreen:Boolean = false;
		
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
				SaffronLogger.log("Distriqt media player is not supporting this device");
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
			SaffronLogger.log("DevicePrefrence.isPortrait() : " + DevicePrefrence.isPortrait());
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
			
			SaffronLogger.log("lastPortrateOrientetion : " + lastPortrateOrientetion);
			SaffronLogger.log("lastLandscapeOrientation : " + lastLandscapeOrientation);
			
			SaffronLogger.log(" stage.orientation : " + stage.orientation + " vs " + stage.deviceOrientation);
			
			try
			{
				SaffronLogger.log("listen to rotation: isFullScreen : " + isFullScreen);
				if (isFullScreen)
				{
					if (stage.deviceOrientation == StageOrientation.DEFAULT || stage.deviceOrientation == StageOrientation.UPSIDE_DOWN)
					{
						SaffronLogger.log("Make it exit from full screen : " + player);
						//Make it exit from full screen ;
						//player.setFullscreen( false );
						//isFullScreen = false ;
						if (manualFullscreen == false)
							player.setFullscreen(false);
					}
					else if (isLandScape(stage.orientation))// if(stage.orientation != revertLandScape(stage.deviceOrientation))
					{
						SaffronLogger.log("Need to rotate to : " + stage.deviceOrientation);
						stage.setOrientation(revertLandScape(stage.deviceOrientation));
					}
				}
				else
				{
					if (stage.deviceOrientation == StageOrientation.ROTATED_RIGHT || stage.deviceOrientation == StageOrientation.ROTATED_LEFT)
					{
						//Enter full screen
						SaffronLogger.log("Make it full screen : " + player);
						//player.setFullscreen( true );
						//isFullScreen = true ;
						dynamicFullscreen = true;
						player.setFullscreen(true);
					}
				}
			}
			catch (e:Error)
			{
				SaffronLogger.log("!!!!! Something happend: " + e.message);
			}
			
			lastStageorientetion = stage.orientation;
			lastDeviceOriention = stage.deviceOrientation;
		}
		
		public function playVideo(videoURL:String, autoPlay:Boolean = true, showControlls:Boolean=true,manualControl:Boolean=false,backGroundColor:uint=0xFF000000):void
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
			player = (MediaPlayerClass as Object).service.createPlayerView(new MediaPlayerOptionsClass().setViewport(rect).setAutoPlay(true).showControls(showControlls).enableBackgroundAudio(false).setBackgroundColour(backGroundColor));
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

			//player.addEventListener(MediaPlayerEventClass.FULLSCREEN_ENTER, isFullscreened);
		//	player.addEventListener(MediaPlayerEventClass.FULLSCREEN_EXIT, exitFullscreened);
			player.addEventListener(MediaPlayerEventClass.LOADING, isLoading);
			player.addEventListener(MediaPlayerEventClass.READY, isReady);
			player.addEventListener(MediaPlayerEventClass.COMPLETE,completeTrack)
			
			//player.addEventListener(MediaPlayerEventClass.LOADED, isPlaying);
			//player.addEventListener(MediaPlayerEventClass.CLICK, isPlaying);
			//player.addEventListener(com.distriqt.extension.mediaplayer.events.MediaPlayerEvent.STOPPED,exitFullscreened);
			this.removeEventListener(Event.ENTER_FRAME, controlPlayerViewPort);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, unLoad);

			if(manualControl==true){
				player.addEventListener(MediaPlayerEventClass.CLICK,changeFullScreen);
			}
			else
			{
				player.addEventListener(MediaPlayerEventClass.FULLSCREEN_ENTER, isFullscreened);
				player.addEventListener(MediaPlayerEventClass.FULLSCREEN_EXIT, exitFullscreened);
				this.addEventListener(Event.ENTER_FRAME, controlPlayerViewPort);
			}
		}

		private function completeTrack(e:Event=null):void{
			this.dispatchEvent(new Event(Event.COMPLETE,true));
		}

		public function changeFullScreen(e:Event=null):void
		{
			if(isFullScreen)
			{
				isFullScreen=false;
				var rect:Rectangle = createVewPort();
				player.resize(rect.x, rect.y, rect.width, rect.height);
				this.dispatchEvent(new Event(Event.VIDEO_FRAME,true));
			}
			else
			{
				isFullScreen = true;
				var sclX:Number = (stage.fullScreenWidth / appStageWidth);
				var sclY:Number = (stage.fullScreenHeight / appStageHeight);
				if (sclX <= sclY)
				{
					scl = sclX;
				}
				else
				{
					scl = sclY;
				}
				this.dispatchEvent(new Event(Event.FULLSCREEN,true));
				player.resize(0, 0, Math.round(Contents.config.stageRect.width * scl),  Math.round(Contents.config.stageRect.height * scl));
				
			}
		}
		
		private function band_test(e):void
		{
			SaffronLogger.log("testSpeed:" + e.target.last_speed() + ' kb/s')
		}
		
		private function play_video(e):void
		{
			var bw = e.target.getBandwidth();
			
			SaffronLogger.log("Final bandwidth: " + bw + ' kb/s');
			SaffronLogger.log("Peak bandwidth: " + e.target.getPeak() + ' kb/s');
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
				SaffronLogger.log('Could not find video.');
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
				player.seek(position);
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
			SaffronLogger.log("*** *** ***** isLoading 1 : " + isLoading);
		}
		
		/**Is Loaded*/
		private function isLoaded(e:*):void
		{
			SaffronLogger.log("*** *** ***** isLoaded 2 : " + isLoaded);
		
		}
		
		/**is exited from full screen*/
		protected function exitFullscreened(event:Event):void
		{
			manualFullscreen = false;
			dynamicFullscreen = false;
			SaffronLogger.log("*** Exit full screen !! : " + event);
			if (/*isFullScreen && */DevicePrefrence.isPortrait())
			{
				stage.setOrientation(lastPortrateOrientetion);
				SaffronLogger.log("StageOrientation1. >>> " + lastPortrateOrientetion);
			}
			isFullScreen = false;
		}
		
		/**is full screen now*/
		protected function isFullscreened(event:Event):void
		{
			SaffronLogger.log("*** Set full screen !! : " + event);
			if (/*!isFullScreen && */DevicePrefrence.isPortrait() && isFullScreen != true)
			{
				if (!DevicePrefrence.isIOS())
				{
					var toLanscapeOrientation:String = revertLandScape(lastLandscapeOrientation);
					stage.setOrientation(toLanscapeOrientation);
				}
				SaffronLogger.log("StageOrientation2. >>> " + toLanscapeOrientation);
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
			/*SaffronLogger.log("|rect : "+rect);
			
			   SaffronLogger.log("stage.fullScreenHeight : "+stage.fullScreenHeight);
			   SaffronLogger.log("stage.fullScreenWidth : "+stage.fullScreenWidth);
			   SaffronLogger.log("stage.stageHeight : "+stage.stageHeight);
			   SaffronLogger.log("stage.stageWidth : "+stage.stageWidth);
			   SaffronLogger.log("appStageWidth : "+appStageWidth);
			   SaffronLogger.log("appStageHeight : "+appStageHeight);*/
			
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
			
			/*SaffronLogger.log("scl : "+scl);
			   SaffronLogger.log("deltaY : "+deltaY);
			   SaffronLogger.log("deltaX : "+deltaX);*/
			
			rect.x *= scl;
			rect.y *= scl;
			rect.x += deltaX / 2;
			rect.y += deltaY / 2;
			//rect.y-=30;
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
			SaffronLogger.log("Hide the player");
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
					SaffronLogger.log("Remove player");
					//player.removeEventListener(com.distriqt.extension.mediaplayer.events.MediaPlayerEvent.STOPPED,exitFullscreened);
					player.destroy();
					player = null;
					
					
				}
				catch (e)
				{
					SaffronLogger.log(">>e" + e);
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

		public function PlayPauseVideo(pause:Boolean):void
		{
			if(pause==true)
				player.pause();
			else
				player.play();
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
			SaffronLogger.log("++++Distriqt media player starts+++");
			try
			{
				MediaPlayerClass = getDefinitionByName("com.distriqt.extension.mediaplayer.MediaPlayer") as Class;
				MediaPlayerOptionsClass = getDefinitionByName("com.distriqt.extension.mediaplayer.MediaPlayerOptions") as Class;
				MediaPlayerEventClass = getDefinitionByName("com.distriqt.extension.mediaplayer.events.MediaPlayerEvent") as Class;
				SaffronLogger.log("+++Media player starts+++");
			}
			catch (e)
			{
				MediaPlayerClass = null;
				MediaPlayerOptionsClass = null;
				MediaPlayerEventClass = null;
				isSupports = false;
				SaffronLogger.log('*********************** You dont have com.distriqt.extension.mediaplayer.MediaPlayer embeded in your project **************************');
				return;
			}
			try
			{
				//(MediaPlayerClass as Object).init(myDistriqtId);
				if ((MediaPlayerClass as Object).isSupported)
				{
					isSupports = true;
					SaffronLogger.log("+++Media player is supports+++");
				}
				else
				{
					SaffronLogger.log("+++media player is not supports+++");
				}
			}
			catch (e:Error)
			{
				SaffronLogger.log("+++Distriqt media player isSupports : " + e);
				isSupports = false;
			}
		}

		
	}
}