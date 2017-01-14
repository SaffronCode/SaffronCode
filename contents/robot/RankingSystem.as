package contents.robot
{
	import contents.Contents;
	
	import dataManager.GlobalStorage;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import popForm.PopButtonData;
	import popForm.PopMenuContent;
	import popForm.PopMenuEvent;

	public class RankingSystem
	{
		private static const id_whatch_duration:String="id_whatch_duration",
							id_is_ranked:String="id_is_ranked",
							id_dont_open_again:String="id_dont_open_again";
		
		/**This is the time in mili seconds*/
		private static var userWatchedDuration:int ;
		
		public static var requiredDurationTime:uint = 1000*60*40; //40 minauts
		
		private static var intervalId:uint;
		
		private static const intervalCountDown:uint = 1000 ;
		
		
		private static const lang_yes:String = 'yes',
							lang_later:String = 'later',
							lang_do_you_whant_to_rank:String = "do_you_whant_to_rank",
							lang_dont_remind_me_again:String = "dont_remind_me_again";
					
		
		/**Start counting*/
		public static function start(event:*=null):void
		{
			//Debugging line for reseting the values
			//GlobalStorage.save(id_is_ranked,false);
			var data:* = GlobalStorage.load(id_whatch_duration); 
			if(data != null)
			{
				userWatchedDuration = data;
			}
			else
			{
				userWatchedDuration = 0 ;
			}
			
			startCounting();
			
			if(	Contents.lang.t[lang_yes] == undefined)
			{
				throw "Add the main languages tags to the language.xml\n" +
					"\t<yes>\n\t\t<fa>بله</fa>\n\t</yes>";
			}
			else if(Contents.lang.t[lang_do_you_whant_to_rank] == undefined
				||
				Contents.lang.t[lang_dont_remind_me_again] == undefined
				||
				Contents.lang.t[lang_later] == undefined)
			{
				throw "Add the RankinhSystem languages tags to the language.xml\n" +
					"\t<do_you_whant_to_rank>\n\t\t<fa>برای کمک به بهبود، آیا به نرم افزار امتیاز می دهی؟</fa>\n\t</do_you_whant_to_rank>" +
					"\n\t<dont_remind_me_again>\n\t\t<fa>یاداوری نکن</fa>\n\t</dont_remind_me_again>" +
					"\n\t<later>\n\t\t<fa>بعداً</fa>\n\t</later>";
			}
		}
		
		/**Start counding*/
		private static function startCounting(e:*=null):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE,startCounting);
			if(GlobalStorage.load(id_is_ranked)!=true && GlobalStorage.load(id_dont_open_again)!=true)
			{
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,stopCounting);
				intervalId = setInterval(controllTime,intervalCountDown);
			}
		}
		
		/**Stop counting*/
		private static function stopCounting(e:*=null):void
		{
			GlobalStorage.save(id_whatch_duration,userWatchedDuration);
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE,stopCounting);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,startCounting);
			clearInterval(intervalId);
		}
		
		/**Add miliseconds and controll the time*/
		private static function controllTime():void
		{
			userWatchedDuration+=intervalCountDown;
			
			if(userWatchedDuration>=requiredDurationTime)
			{
				showRankQuestion();
			}
			/*else if(userWatchedDuration%60*1000*5)
			{
				GlobalStorage.save(id_whatch_duration,userWatchedDuration);
			}*/
		}
		
		
		/**Open the questino page*/
		public static function showRankQuestion():void
		{
			
			stopCounting();
			var popButtons:Array = [
					new PopButtonData(Contents.lang.t[lang_yes],0,null,true,false),
					new PopButtonData(Contents.lang.t[lang_yes],0,null,true,false),
					new PopButtonData(Contents.lang.t[lang_yes],0,null,true,false),
				new PopButtonData(Contents.lang.t[lang_yes],1,null,true,true),
				new PopButtonData(Contents.lang.t[lang_later],1,null,true,true),
					new PopButtonData(Contents.lang.t[lang_yes],0,null,true,false),
					new PopButtonData(Contents.lang.t[lang_yes],0,null,true,false),
					new PopButtonData(Contents.lang.t[lang_yes],0,null,true,false),
				new PopButtonData(Contents.lang.t[lang_dont_remind_me_again],1,null,true,true)
			];
			var popContent:PopMenuContent = new PopMenuContent(Contents.lang.t[lang_do_you_whant_to_rank],null,popButtons,null);
			PopMenu1.popUp('',null,popContent,0,onButtonSelected);
		}
		
		
			/**Rank button selected*/
			private static function onButtonSelected(e:PopMenuEvent):void
			{
				switch(e.buttonTitle)
				{
					case String(Contents.lang.t[lang_yes]):
					{
						resetDuration(false);
						DevicePrefrence.rankThisApp(resetDuration,userRanked)
						break;
					}
					case String(Contents.lang.t[lang_dont_remind_me_again]):
					{
						GlobalStorage.save(id_dont_open_again,true);
						break;
					}
					case String(Contents.lang.t[lang_later]):
					default:
					{
						resetDuration();
						break;
					}
				}
			}
		
		
		/**Resting*/
		private static function resetDuration(andStartCounting:Boolean=true):void
		{
			userWatchedDuration = 0 ;
			GlobalStorage.save(id_whatch_duration,userWatchedDuration);
			if(andStartCounting)
			{
				startCounting();
			}
		}
		
		/***/
		private static function userRanked():void
		{
			GlobalStorage.save(id_is_ranked,true);
		}
	}
}