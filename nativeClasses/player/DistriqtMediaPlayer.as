package nativeClasses.player
{
	//import com.distriqt.extension.mediaplayer.MediaPlayer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	
	public class DistriqtMediaPlayer extends Sprite
	{
		/**com.distriqt.extension.mediaplayer.MediaPlayer*/
		private static var MediaPlayerClass:Class ;
		
		private static var myDistriqtId:String ;
		
		private static var isSupports:Boolean = false ;

		private static var 	scl:Number = 0,
							lastStageW:Number=0,
							deltaX:Number,
							deltaY:Number;
		
		private static var 	appStageWidth:Number,
							appStageHeight:Number;
		
		public function DistriqtMediaPlayer(Width:Number,Height:Number)
		{
			super();
			
			if(myDistriqtId==null)
			{
				throw "Set the distriqt id first by calling DistriqtMediaPlayer.setId(...)";
			}
			if(!isSupports)
			{
				trace("Distriqt media player is not supporting this device");
			}
			
			this.graphics.beginFill(0x222222);
			this.graphics.drawRect(0,0,Width,Height);
			if(isNaN(appStageWidth))
			{
				this.addEventListener(Event.ADDED_TO_STAGE,saveStageWidthHeighOnce);
			}
		}
		
		/**Save the stage widh and height once*/
		private function saveStageWidthHeighOnce(e:*):void
		{
			appStageWidth = stage.stageWidth ;
			appStageHeight = stage.stageHeight ;
		}
		
		/**MediaPlayer.CONTROLS_BASIC : controls:basic
MediaPlayer.CONTROLS_EMBEDDED : controls:embedded
MediaPlayer.CONTROLS_FULLSCREEN : controls:fullscreen
MediaPlayer.CONTROLS_NONE : controls:none*/
		public function playVideo(videoURL:String,autoPlay:Boolean=true,controlls:String="controls:fullscreen"):void
		{
			if(this.stage==null)
			{
				throw "Add the player to the stage first";
			}
			
			var rect:Rectangle = createVewPort();
			
			/*rect.x*=scl;
			rect.y*=scl;
			rect.x += deltaX/2;
			rect.y += deltaY/2;
			rect.width*=scl;
			rect.height*=scl;*/
			try
			{
				trace("Remove player");
				(MediaPlayerClass as Object).service.removePlayer();
			}
			catch(e)
			{
				trace(">>e"+e);
			}
			(MediaPlayerClass as Object).service.createPlayer(videoURL,rect.x,rect.y,rect.width,rect.height,autoPlay,controlls,true);
			
			this.removeEventListener(Event.ENTER_FRAME,controlPlayerFrame);
			this.addEventListener(Event.ENTER_FRAME,controlPlayerFrame);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		private function createVewPort():Rectangle
		{
			var rect:Rectangle = this.getBounds(stage);
			trace("|rect : "+rect);
			
			trace("stage.fullScreenHeight : "+stage.fullScreenHeight);
			trace("stage.fullScreenWidth : "+stage.fullScreenWidth);
			trace("stage.stageHeight : "+stage.stageHeight);
			trace("stage.stageWidth : "+stage.stageWidth);
			trace("appStageWidth : "+appStageWidth);
			trace("appStageHeight : "+appStageHeight);
			
			if(scl==0 || lastStageW!=stage.fullScreenWidth)
			{
				lastStageW = stage.fullScreenWidth ;
				
				var sclX:Number = (stage.fullScreenWidth/appStageWidth) ;
				var sclY:Number = (stage.fullScreenHeight/appStageHeight) ;
				
				deltaX = 0 ;
				deltaY = 0 ;
				if(sclX<=sclY)
				{
					scl = sclX ;
					deltaY = stage.fullScreenHeight-(appStageHeight)*scl ;
				}
				else
				{
					scl = sclY ;
					deltaX = stage.fullScreenWidth-(appStageWidth)*scl ;
				}
			}
			
			trace("scl : "+scl);
			trace("deltaY : "+deltaY);
			trace("deltaX : "+deltaX);
			
			rect.x*=scl;
			rect.y*=scl;
			rect.x += deltaX/2;
			rect.y += deltaY/2;
			rect.width*=scl;
			rect.height*=scl;
			
			rect.x = round(rect.x);
			rect.y = round(rect.y);
			rect.width = round(rect.width);
			rect.height = round(rect.height);
			
			return rect ;
		}
		
		protected function unLoad(event:Event):void
		{
			try
			{
				trace("Remove player");
				(MediaPlayerClass as Object).service.removePlayer();
			}
			catch(e)
			{
				trace(">>e"+e);
			}
			this.removeEventListener(Event.ENTER_FRAME,controlPlayerFrame);
		}
		
		/**Controll the player place*/
		protected function controlPlayerFrame(event:Event=null):void
		{
			if(Obj.isAccesibleByMouse(this))
			{
				var rect:Rectangle = createVewPort();
				(MediaPlayerClass as Object).service.resize(rect.x,rect.y,rect.width,rect.height);
			}
			else
			{
				(MediaPlayerClass as Object).service.resize(0,0,0,0);
			}
		}
		
		private function round(num:Number):Number
		{
			return Math.round(num);
		}
		
		public static function setId(distriqtId:String):void
		{
			myDistriqtId = distriqtId ;
			try
			{
				MediaPlayerClass = getDefinitionByName("com.distriqt.extension.mediaplayer.MediaPlayer") as Class ;
			}
			catch(e)
			{
				MediaPlayerClass = null ;
				isSupports = false ;
				trace('*********************** You dont have com.distriqt.extension.mediaplayer.MediaPlayer embeded in your project **************************');
				return ;
			}
			try
			{
				(MediaPlayerClass as Object).init( myDistriqtId );
				if ((MediaPlayerClass as Object).isSupported)
				{
					isSupports = true ;
				}
			}
			catch (e:Error)
			{
				trace("Distriqt media player isSupports : "+ e );
				isSupports = false ;
			}
		}
	}
}