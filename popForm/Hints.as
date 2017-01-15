package popForm
{
	import contents.Contents;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	

	public class Hints
	{
		public static var 	id_no_internet:String = "no_internet",
							id_yes:String = "yes",
							id_back:String = "back",
							id_please_wait:String = "please_wait",
							id_search:String = "search",
							id_no:String = "no";
		
		/**Used when search function has no resutl*/
		public static var id_no_matches_found:String = "no_matches_found";
		
		
		private static const showTimer:uint = 3000 ;
		
		private static var onQuestionAccepted:Function,
							onNotAccepted:Function;
		
		private static var myPreLoader:MovieClip = null;
		
		private static var onWaitClosedUserFunctoin:Function ;
		
		public static function get isOpen():Boolean
		{
			return PopMenu1.isOpen ;
		}
		
		public static function ask(title:String,question:String,onDone:Function,innerDisplayObject:DisplayObject=null,OnNotAccepted:Function=null):void
		{
			onQuestionAccepted = onDone ;
			onNotAccepted = OnNotAccepted ;
			
			var buttons:Array = [new PopButtonData(Contents.lang.t[id_yes],1,null,true,true)
				,new PopButtonData(Contents.lang.t[id_no],1,null,true,true)] ;
			var popText:PopMenuContent = new PopMenuContent(question,null,buttons,innerDisplayObject);
			PopMenu1.popUp(title,null,popText,0,onQuestionAnswered);
		}
		
		private static function onQuestionAnswered(e:PopMenuEvent)
		{
			if(e.buttonTitle == Contents.lang.t[id_yes])
			{
				onQuestionAccepted();
			}
			else
			{
				if(onNotAccepted!=null)
				{
					onNotAccepted();
				}
			}
		}
		
		
		/**Show this hint with PopMenu1
		 * I made canselable default to true to make user confortable to close errors
		 * */
		public static function show(str:String,canselable:Boolean=true,delyTime:int=-1,displayObject:MovieClip=null,title:String='')
		{
			var buttons:Array ;
			if(canselable)
			{
				buttons = [Contents.lang.t[id_back]];
			}
			if(delyTime==-1)
			{
				delyTime = showTimer ;
			}
			var popText:PopMenuContent = new PopMenuContent(str,null,buttons,displayObject);
			PopMenu1.popUp(title,null,popText,delyTime);
		}
		
		/**Show no internet connection available*/
		public static function noInternet()
		{
			show(Contents.lang.t[id_no_internet]);
		}
		
		/**hide hint*/
		public static function hide()
		{
			PopMenu1.close();
			//throw "Hide calls";
		}
		
		
		/**Show the please wait page , you have to close this page manualy<br>
		 * The onCloded function had to get popDataEvent*/
		public static function pleaseWait( onClosed:Function = null )
		{
			var buttons:Array ;
			
			var closeTime:uint = 0 ;
			
			if(onClosed == null)
			{
				closeTime = 40000 ;
				onClosed = new Function();
			}
			else
			{
				buttons = [Contents.lang.t[id_back]] ;
			}
			onWaitClosedUserFunctoin = onClosed ;
			trace("Contents.lang.t[id_please_wait] : "+Contents.lang.t[id_please_wait]);
			var popText:PopMenuContent = new PopMenuContent(Contents.lang.t[id_please_wait],null,buttons,myPreLoader);
			
			PopMenu1.popUp('',null,popText,closeTime,onWaitClosed);
		}
		
		private static function onWaitClosed(e:PopMenuEvent):void
		{
			if(onWaitClosedUserFunctoin.length==0)
			{
				onWaitClosedUserFunctoin();
			}
			else
			{
				onWaitClosedUserFunctoin(e);
			}
		}
		
		
	///////////////////////////////////////////////////////////////////////////////
		
		private static var onSearched:Function,
							onSelected:Function,
							onBacked:Function;
		
		/**Select something from these buttons, but if the onSearchButtn function was not null, it will add search input to<br>
		 * onButtonSelected : function(e:PopMenuEvent);<br>
		 * onSearchButton : function(searchParam:String);*/
		public static function selector(title:String,text:String,buttonsList:Array,onButtonSelected:Function,onSearchButton:Function=null,defButtonFrame:uint=1,itemFrame:uint=2,onBackFUnction:Function = null,backButtonFrame:int=1):void
		{
			var moreHint:String = '' ;
			var namesArray:Array ;
			var popField:PopMenuFields = new PopMenuFields();
			
			onSearched = onSearchButton ;
			onSelected = onButtonSelected ;
			onBacked = onBackFUnction ;
			
			var backButton:PopButtonData = new PopButtonData(Contents.lang.t[id_back],backButtonFrame);
			
			if( onSearched != null )
			{
				namesArray = [Contents.lang.t[id_search],backButton,''] ;
			}
			else
			{
				namesArray = [backButton,''] ;
			}
			namesArray = namesArray.concat(buttonsList);
			trace("namesArray : "+namesArray.length);
			
			if(namesArray.length <= 3)
			{
				moreHint = Contents.lang.t[id_no_matches_found]+'\n' ;
			}
			
			if(onSearched != null)
			{
				popField.addField(Contents.lang.t[id_search],'');
			}
			var popText:PopMenuContent = new PopMenuContent(moreHint+text,popField,namesArray,null,[defButtonFrame,defButtonFrame,itemFrame]);
			PopMenu1.popUp(title,null,popText,0,someThingSelected);
		}
		
		private static function someThingSelected(e:PopMenuEvent):void
		{
			if(e.buttonTitle == Contents.lang.t[id_back])
			{
				trace("let this menu close");
				if(onBacked!=null)
				{
					onBacked();
				}
			}
			else if(e.buttonTitle == Contents.lang.t[id_search])
			{
				//Start search again
				onSearched(e.field[Contents.lang.t[id_search]]);
			}
			else
			{
				onSelected(e);
			}
		}
		
		public static function setPreLoader(preLoaderMC:MovieClip):void
		{
			
			myPreLoader = preLoaderMC ;
		}
	}
}