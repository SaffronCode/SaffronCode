package mp3PlayerStatic
	//mp3PlayerStatic.MediaPlayerStatic
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
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
			
		
		private var autoPlay:Boolean;
			
		private var precentTF:TextField ;		
					
		private var SoundIsLoaded:Boolean = false;
						
		private var urlController:URLSaver ;
		
		private var offlineURL:String ;
		
		private var mediaSoundID:uint = 2 ;
			
		public function MediaPlayerStatic()
		{
			super();
			

				SoundPlayer.setUp(stage);
			
		
			precentTF = Obj.get("precent_txt",this);
			precentTF.text = '' ;
			precentTF.mouseEnabled = false;
						
			urlController = new URLSaver(true);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			
			this.addEventListener(MediaPlayerEventStatic.PAUSE,puseMeiaPlayer)
			this.addEventListener(MediaPlayerEventStatic.STOP,stopMediaPLayer)
			this.addEventListener(MediaPlayerEventStatic.PLAY,playMediaPlayer)
			this.addEventListener(MediaPlayerEventStatic.CURRENT_PRECENT,onPrecentChanged)	
			
			//Debug line ↓
				//setUp("E:/music/Super Instrumental/1995 - Super Instrumental 05/08. Fausto Papetti - Besame Mucho.mp3");
		}
		
		protected function puseMeiaPlayer(event:Event):void
		{
			// TODO Auto-generated method stub
			if(SoundIsLoaded)
			{
				SoundPlayer.pause(mediaSoundID,true);
				playStatus = false
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
			}
		}
		
		protected function unLoad(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.removeEventListener(Event.ENTER_FRAME,checkPrecent);
			SoundPlayer.pause(mediaSoundID);
			SoundPlayer.removeSound(mediaSoundID);
		}
		
		/**Set the sound URL*/
		private function setUp(soundURL_p:String,AutoPlay_p:Boolean)
		{
			playStatus = AutoPlay_p	
			autoPlay = AutoPlay_p;
			
			urlController.addEventListener(URLSaverEvent.LOAD_COMPLETE,SoundIsReady);
			urlController.addEventListener(URLSaverEvent.LOADING,Loading);
			urlController.addEventListener(URLSaverEvent.NO_INTERNET,TryLater);
			urlController.load(soundURL_p);
		}
		
		public static function setup(soundURL_p:String,AutoPlay_p:Boolean=false):void
		{
			evt = new MediaPlayerStatic()
			evt.setUp(soundURL_p,AutoPlay_p)	
		}
		
		
		protected function TryLater(event:URLSaverEvent):void
		{
			// TODO Auto-generated method stub
			trace("Internet connection fails , but I will try again ... ");
		}
		
		protected function Loading(event:URLSaverEvent):void
		{
			// TODO Auto-generated method stub
			trace("Im downloading..1:"+event.precent );
			trace("Im downloading..2:"+  String( event.precent*100 ).substr(0,3)  ); 
			precentTF.text = Math.round(Number(String( event.precent*100 ).substr(0,3))) +' %';
		}
		
		protected function SoundIsReady(event:URLSaverEvent):void
		{
			// TODO Auto-generated method stub
			trace("sound file is ready to use");
			startToPlaySound(event.offlineTarget);
		}
		
		
		
		private function startToPlaySound(offlineTarget:String):void
		{
			// TODO Auto Generated method stub
			offlineURL = offlineTarget ;
			SoundIsLoaded = true ;
			precentTF.text = '' ;
			SoundPlayer.addSound(offlineURL,mediaSoundID,false,1);
			this.addEventListener(Event.ENTER_FRAME,checkPrecent);
			
			if(autoPlay)
			{
				this.dispatchEvent(new MediaPlayerEventStatic(MediaPlayerEventStatic.PLAY))
			}
			
			isReady = true
		}		
		
		
		
		/**Sync the slider precent with SoundPlayer*/
		private function checkPrecent(e:Event)
		{
			this.dispatchEvent(new MediaPlayerEventStatic(MediaPlayerEventStatic.SOUND_PRESENT,1,1,SoundPlayer.getPlayedPrecent(mediaSoundID)))
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