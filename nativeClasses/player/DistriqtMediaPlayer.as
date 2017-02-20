package nativeClasses.player
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	public class DistriqtMediaPlayer extends Sprite
	{
		/**com.distriqt.extension.mediaplayer.MediaPlayer*/
		private static var MediaPlayerClass:Class ;
		
		private static var myDistriqtId:String ;
		
		private static var isSupports:Boolean = false ;

		private static var 	scl:Number = 0,
							deltaX:Number,
							deltaY:Number;
		
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
		}
		
		/**MediaPlayer.CONTROLS_BASIC : controls:basic
MediaPlayer.CONTROLS_EMBEDDED : controls:embedded
MediaPlayer.CONTROLS_FULLSCREEN : controls:fullscreen
MediaPlayer.CONTROLS_NONE : controls:none*/
		public function playVideo(videoURL:String,autoPlay:Boolean=true,controlls:String="controls:basic"):void
		{
			if(this.stage==null)
			{
				throw "Add the player to the stage first";
			}
			var rect:Rectangle = this.getBounds(stage);
			trace("|rect : "+rect);
			trace("videoURL : "+videoURL);
			
			trace("stage.fullScreenHeight : "+stage.fullScreenHeight);
			trace("stage.fullScreenWidth : "+stage.fullScreenWidth);
			trace("stage.stageHeight : "+stage.stageHeight);
			trace("stage.stageWidth : "+stage.stageWidth);
			
			if(scl==0)
			{
				
				var sclX:Number = (stage.fullScreenWidth/stage.stageWidth) ;
				var sclY:Number = (stage.fullScreenHeight/stage.stageHeight) ;
				
				deltaX = 0 ;
				deltaY = 0 ;
				if(sclX<=sclY)
				{
					scl = sclX ;
					deltaY = stage.fullScreenHeight-(stage.stageHeight)*scl ;
				}
				else
				{
					scl = sclY ;
					deltaX = stage.fullScreenWidth-(stage.stageWidth)*scl ;
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
		}
		
		public static function setId(distriqtId:String):void
		{
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
			myDistriqtId = distriqtId ;
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