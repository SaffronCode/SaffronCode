package mp3PlayerStatic
	//mp3PlayerStatic.MediaPlayerStatic
{
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import netManager.urlSaver.URLSaver;
	import netManager.urlSaver.URLSaverEvent;
	
	import soundPlayer.SoundPlayer;
	
	[Event(name="PLAY", type="mp3PlayerStatic.MediaPlayerEventStatic")]
	[Event(name="PAUSE", type="mp3PlayerStatic.MediaPlayerEventStatic")]
	[Event(name="STOP", type="mp3PlayerStatic.MediaPlayerEventStatic")]
	[Event(name="VOLUME", type="mp3PlayerStatic.MediaPlayerEventStatic")]
	[Event(name="CURRENT_PRECENT", type="mp3PlayerStatic.MediaPlayerEventStatic")]
	[Event(name="SOUND_PRESENT", type="mp3PlayerStatic.MediaPlayerEventStatic")]

	
	public class MediaPlayerStatic extends MovieClip
	{

		public static var evt:MediaPlayerStatic		
		public static var playStatus:Boolean=false
		public static var currentPrecent:Number=1
		public static var isReady:Boolean = false	
		public static var volume:Number=0.5	
		public static  var mediaSoundID:uint = 0 ;	
			
		
		private var autoPlay:Boolean;
								
		private var SoundIsLoaded:Boolean = false;
						
		private var urlController:URLSaver ;
		
		private var offlineURL:String ;
		
		private var mediaSoundID:uint = 2 ;
			
		public function MediaPlayerStatic()
		{
			super();
			


			urlController = new URLSaver(true);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			
			this.addEventListener(MediaPlayerEventStatic.PAUSE,puseMeiaPlayer)
			this.addEventListener(MediaPlayerEventStatic.STOP,puseMeiaPlayer)
			this.addEventListener(MediaPlayerEventStatic.PLAY,playMediaPlayer)
			this.addEventListener(MediaPlayerEventStatic.CURRENT_PRECENT,onPrecentChanged)	
			this.addEventListener(MediaPlayerEventStatic.VOLUME,getVolume)	
			
			//Debug line ↓
				//setUp("E:/music/Super Instrumental/1995 - Super Instrumental 05/08. Fausto Papetti - Besame Mucho.mp3");
		}
		
		protected function getVolume(event:MediaPlayerEventStatic):void
		{
			// TODO Auto-generated method stub
			volume = event.volumeNumber
			SoundPlayer.volumeContril(mediaSoundID,volume)	
		}
		
		protected function puseMeiaPlayer(event:Event):void
		{
			// TODO Auto-generated method stub
			if(SoundIsLoaded)
			{
				SoundPlayer.pause(mediaSoundID,true);
				playStatus = false
				this.removeEventListener(Event.ENTER_FRAME,checkPrecent);	
			}
		}
		
		protected function stopMediaPLayer(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function playMediaPlayer(event:Event):void
		{
			// TODO Auto-generated method stub
			if(SoundIsLoaded)
			{
				SoundPlayer.play(mediaSoundID,true);
				playStatus = true
				this.addEventListener(Event.ENTER_FRAME,checkPrecent);	
			}
		}
		
		protected function unLoad(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.removeEventListener(Event.ENTER_FRAME,checkPrecent);
			
			//SoundPlayer.pause(mediaSoundID);
			//SoundPlayer.removeSound(mediaSoundID);
		}
		
		/**Set the sound URL*/
		private function setUp(Stage_p:Stage,soundURL_p:String,AutoPlay_p:Boolean,DownLoadCompeletAndPlay_p)
		{
			//SoundPlayer.setUp(Stage_p,true);
			SoundPlayer.pause(mediaSoundID,true);
			playStatus = false
			playStatus = AutoPlay_p	
			autoPlay = AutoPlay_p;
			if(!DownLoadCompeletAndPlay_p && urlController.offlineURL!=null)
			{				
				urlController.addEventListener(URLSaverEvent.LOAD_COMPLETE,SoundIsReady);
				urlController.addEventListener(URLSaverEvent.LOADING,Loading);
				urlController.addEventListener(URLSaverEvent.NO_INTERNET,TryLater);
				urlController.load(soundURL_p);
			}
			else if(!DownLoadCompeletAndPlay_p && urlController.offlineURL==null)
			{
				urlController.addEventListener(URLSaverEvent.LOADING,Loading);
				urlController.addEventListener(URLSaverEvent.NO_INTERNET,TryLater);
				urlController.load(soundURL_p);
				startToPlaySound(soundURL_p);
			}
			else if(DownLoadCompeletAndPlay_p)
			{
				urlController.addEventListener(URLSaverEvent.LOAD_COMPLETE,SoundIsReady);
				urlController.addEventListener(URLSaverEvent.LOADING,Loading);
				urlController.addEventListener(URLSaverEvent.NO_INTERNET,TryLater);
				urlController.load(soundURL_p);
			}
		}
		
		public static function setup():void
		{
			evt = new MediaPlayerStatic()
		}
		public static function update(Stage_p,soundURL_p:String,MediaSoundID_p:uint=1,AutoPlay_p:Boolean=false,DownLoadCompeletAndPlay_p:Boolean =false):void
		{
			mediaSoundID = MediaSoundID_p ;
			evt.setUp(Stage_p,soundURL_p,AutoPlay_p,DownLoadCompeletAndPlay_p)
		}
		
		
		protected function TryLater(event:URLSaverEvent):void
		{
			// TODO Auto-generated method stub
			trace("Internet connection fails , but I will try again ... ");
		}
		
		protected function Loading(event:URLSaverEvent):void
		{
			// TODO Auto-generated method stub
			loadingPrecent(event.precent)			
		}
		protected function loadingPrecent(Precent_p:Number):void
		{
			trace("Im downloading..1:"+Precent_p );
			trace("Im downloading..2:"+  String( Precent_p*100 ).substr(0,3)  ); 
			var _precent:Number = Math.round(Number(String(Precent_p*100 ).substr(0,3)));		
			this.dispatchEvent(new MediaPlayerEventStatic(MediaPlayerEventStatic.DOWNLOAD_PRECENT,1,1,1,_precent))
		}
		
		protected function SoundIsReady(event:URLSaverEvent):void
		{
			// TODO Auto-generated method stub
			startToPlaySound(event.offlineTarget);
		}
				
		private function startToPlaySound(offlineTarget:String):void
		{
			// TODO Auto Generated method stub
			offlineURL = offlineTarget ;
			SoundIsLoaded = true;
			SoundPlayer.addSound(offlineURL,mediaSoundID,false,1);
		
			if(autoPlay)
			{
				this.addEventListener(Event.ENTER_FRAME,checkPrecent);
				this.dispatchEvent(new MediaPlayerEventStatic(MediaPlayerEventStatic.PLAY))
			}		
			isReady = true
		}		
		
		var bytArray:ByteArray =  new ByteArray()	
		
		/**Sync the slider precent with SoundPlayer*/
		private function checkPrecent(e:Event)
		{
			loadingPrecent(SoundPlayer.getLoadedSoundPrecent(mediaSoundID))	
			this.dispatchEvent(new MediaPlayerEventStatic(MediaPlayerEventStatic.SOUND_PRESENT,1,1,SoundPlayer.getPlayedPrecent(mediaSoundID)))
			//SoundPlayer.getExtractedData(mediaSoundID,bytArray)
			//trace('bytArray :',bytArray.readInt())	
		}
		
		
		/**precent changed by client*/
		private function onPrecentChanged(event:MediaPlayerEventStatic)
		{
			if(SoundIsLoaded)
			{
				SoundPlayer.pause(mediaSoundID,true);
				SoundPlayer.play(mediaSoundID,true,true,event.currentPrecent);
			}
		}		
				
	}
}