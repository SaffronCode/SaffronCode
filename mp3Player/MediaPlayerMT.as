package mp3Player
	//mp3Player.MediaPlayerMT
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import netManager.urlSaver.URLSaver;
	import netManager.urlSaver.URLSaverEvent;
	
	import soundPlayer.SoundPlayer;
	import soundPlayer.SoundPlayerEvent;
	
	
	public class MediaPlayerMT extends MovieClip
	{
		private var playPauseBTN:MovieClip;
		
		private var precentTF:TextField ;	
		
		private var 	currentTF:TextField,
								totalTF:TextField;
		
		private var sliderMC:MediaSlider ;
		
		
		private var SoundIsLoaded:Boolean = false;
		
		private var mainColor:uint = 0x184A85 ;
		
		private var backColor:uint = 0xFFFFFF ;
		
		
		private var urlController:URLSaver ;
		
		private var offlineURL:String ;
		
		private var mediaSoundID:uint = 2 ;
		private var autoPlay:Boolean;
		private var timeOutId:uint;
		
		private var currentMuseicTotalTimeInMilisecond:uint ;
		
		private var 	stepForwardMC:MovieClip,
								stepBackwardMC:MovieClip;
		
		
		public function MediaPlayerMT()
		{
			super();
			
			//SetUp SoundPlayer class in stand alone mode
				SoundPlayer.setUp(stage);
			
			playPauseBTN = Obj.get("button_mc",this);
			playPauseBTN.stop();
			playPauseBTN.buttonMode = true ;
			playPauseBTN.addEventListener(MouseEvent.CLICK,toglleSoundIfLoaded);
			
			stepForwardMC = Obj.get("step_next_mc",this);
			stepBackwardMC = Obj.get("step_back_mc",this);
			
			precentTF = Obj.get("precent_txt",this);
			precentTF.text = '' ;
			precentTF.mouseEnabled = false;
			
			currentTF = Obj.get("current_txt",this);
			totalTF = Obj.get("total_txt",this);
			
			sliderMC = Obj.get("slider_mc",this);
			//sliderMC.height = playPauseBTN.height ;
			
			urlController = new URLSaver(true);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			
			//Debug line ↓
				//setUp("E:/music/Super Instrumental/1995 - Super Instrumental 05/08. Fausto Papetti - Besame Mucho.mp3");
		}
		
		protected function unLoad(event:Event):void
		{
			clearInterval(timeOutId);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.removeEventListener(Event.ENTER_FRAME,checkPrecent);
			stop();
		}
		
		override public function stop():void
		{
			SoundPlayer.pause(mediaSoundID);
			SoundPlayer.removeSound(mediaSoundID);
		}
		
		/**Set the sound URL*/
		public function setUp(soundURL:String,AutoPlay:Boolean=false,BackColor:int=-1,MainColor:int=-1,playItOnline:Boolean=false)
		{
			if(BackColor!=-1)
			{
				backColor = BackColor;
			}
			if(MainColor!=-1)
			{
				mainColor = MainColor;
			}
			
			if(stepForwardMC!=null && stepBackwardMC!=null)
			{
				stepForwardMC.addEventListener(MouseEvent.CLICK,stepForwardFunction);
				stepBackwardMC.addEventListener(MouseEvent.CLICK,stepbackwardFunction);
			}
			
			sliderMC.y = 0 ;
			sliderMC.setUp(mainColor,backColor,onPrecentChanged);
			autoPlay = AutoPlay ;
			
			if(playItOnline)
			{
				startToPlaySound(soundURL);
			}
			else
			{
				urlController.addEventListener(URLSaverEvent.LOAD_COMPLETE,SoundIsReady);
				urlController.addEventListener(URLSaverEvent.LOADING,Loading);
				urlController.addEventListener(URLSaverEvent.NO_INTERNET,TryLater);
				urlController.load(soundURL);
			}
		}
		
		protected function stepbackwardFunction(event:MouseEvent):void
		{
			SoundPlayer.stepBackward(mediaSoundID);
		}
		
		protected function stepForwardFunction(event:MouseEvent):void
		{
			SoundPlayer.stepForward(mediaSoundID);
		}		
		
		
		
		protected function TryLater(event:URLSaverEvent):void
		{
			
			trace("Internet connection fails , but I will try again ... ");
		}
		
		protected function Loading(event:URLSaverEvent):void
		{
			
			trace("Im downloading..1:"+event.precent );
			trace("Im downloading..2:"+  String( event.precent*100 ).substr(0,3)  ); 
			precentTF.text = Math.round(Number(String( event.precent*100 ).substr(0,3))) +' %';
		}
		
		protected function SoundIsReady(event:URLSaverEvent):void
		{
			
			trace("sound file is ready to use");
			startToPlaySound(event.offlineTarget);
		}
		
		
		
		private function startToPlaySound(offlineTarget:String):void
		{
			
			offlineURL = offlineTarget ;
			SoundIsLoaded = true ;
			precentTF.text = '' ;
			sliderMC.userSlideEnabled();
			//trace("Add my sound to sound player");
			SoundPlayer.addSound(offlineURL,mediaSoundID,false,1);
			this.addEventListener(Event.ENTER_FRAME,checkPrecent);
			
			sliderMC.setPrecent(0);
			
			if(autoPlay)
			{
				SoundPlayer.play(mediaSoundID,true);
				playPauseBTN.gotoAndStop(2);
			}
			

			
			
			clearInterval(timeOutId);
			if(totalTF!=null && currentTF!=null)
			{
				currentMuseicTotalTimeInMilisecond = 0 ;
				timeOutId = setInterval(showTimes,500);
				showTimes();
			}
		}		
		

		
		private function showTimes():void
		{
			if(currentMuseicTotalTimeInMilisecond==0)
			{
				currentMuseicTotalTimeInMilisecond = SoundPlayer.getMusicTime(mediaSoundID);
				totalTF.text = TimeToString.timeInString(Math.round( currentMuseicTotalTimeInMilisecond/1000));
			}
			
			var precent:Number = SoundPlayer.getPlayedPrecent(mediaSoundID) ;
			//trace("Sound precent is : "+precent);
			currentTF.text = TimeToString.timeInString(Math.round(precent*(currentMuseicTotalTimeInMilisecond/1000)));
		}
		
		
		/**Sync the slider precent with SoundPlayer*/
		private function checkPrecent(e:Event)
		{
			sliderMC.setPrecent(SoundPlayer.getPlayedPrecent(mediaSoundID));
		}
		
		
		
		
		
		
		
		
		protected function toglleSoundIfLoaded(event:MouseEvent):void
		{
			
			if(SoundIsLoaded)
			{
				if(playPauseBTN.currentFrame == 1)
				{
					SoundPlayer.play(mediaSoundID,true);
					playPauseBTN.gotoAndStop(2);
				}
				else
				{
					SoundPlayer.pause(mediaSoundID,true);
					playPauseBTN.gotoAndStop(1);
				}
			}
		}
		
		/**precent changed by client*/
		private function onPrecentChanged(newPrecetn:Number)
		{
			if(SoundIsLoaded)
			{
				//trace("new precent seleced : "+newPrecetn);
				SoundPlayer.pause(mediaSoundID,true);
				SoundPlayer.play(mediaSoundID,true,true,newPrecetn);
				playPauseBTN.gotoAndStop(2);
			}
		}
	}
}