package popForm
{
	import contents.Contents;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.SoftKeyboardType;
	import contents.multiLanguage.Language;
	

	public class Hints
	{
		public static var 	id_no_internet:String = "no_internet",
							id_yes:String = "yes",
							id_submit:String = "id_submit",
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
		
		private static var _onClose:Function;
		
		public static function get isOpen():Boolean
		{
			return PopMenu1.isOpen ;
		}
		
		
		private static function controllConfig():void
		{
			if(Contents.lang==null)
			{
				Contents.lang = new Language();
				Contents.lang.t[id_no_internet] = "Connection Error" ;
				Contents.lang.t[id_yes] = "Yes";
				Contents.lang.t[id_submit] = "Submit";
				Contents.lang.t[id_back] = "Back";
				Contents.lang.t[id_please_wait] = "Please wait";
				Contents.lang.t[id_search] = "Search";
				Contents.lang.t[id_no] = "No";
			}
		}
		
		public static function ask(title:String,question:String,onDone:Function,innerDisplayObject:DisplayObject=null,OnNotAccepted:Function=null,ButtonFrameYes:int=1,ButtonFrameNo:int=1,descriptionFieldLines:uint=0,
								   extraDesctiptionLabel:String="توضیح:",defaultExtraDescription="",extraDescriptionKeyboard:String=SoftKeyboardType.DEFAULT):void
		{
			onQuestionAccepted = onDone;
			onNotAccepted = OnNotAccepted;
		
			controllConfig();

			var buttons:Array = [new PopButtonData(Contents.lang.t[id_yes],ButtonFrameYes,null,true,true)
				,new PopButtonData(Contents.lang.t[id_no],ButtonFrameNo,null,true,true)] ;
			var popFields:PopMenuFields;
			if(descriptionFieldLines>0)
			{
				popFields = new PopMenuFields();
				popFields.addField(extraDesctiptionLabel,defaultExtraDescription,extraDescriptionKeyboard,false,true,true,descriptionFieldLines,1,1,0,false,true);
			}
			var popText:PopMenuContent = new PopMenuContent(question,popFields,buttons,innerDisplayObject);
			PopMenu1.popUp(title,null,popText,0,onQuestionAnswered);

		}
		
		
		/** if you want to get value of text field, you must define a function with input PopMenuEvent Parameter and give result as dynamic object<br/>
		 * for example :<br/>
		 * Hints.getText("", "", credit, outputFunction);<br/>
		 *  function outputFunction(evt:PopMenuEvent):void<br/>
			{<br/>
				Alert.show(String(evt.field[credit]));<br/>
			}<br/>
		*/
		public static function getText(title:String,question:String,tagLable:String,onDone:Function,OnNotAccepted:Function=null,keyboardType:String=SoftKeyboardType.DEFAULT,isPassword:Boolean=false,innerDisplayObject:DisplayObject=null,ButtonFrameYes:int=1,ButtonFrameNo:int=1,defaultTextOnField:String=''):void
		{
			controllConfig();
			onQuestionAccepted = onDone;
			onNotAccepted = OnNotAccepted;
			
			var buttons:Array = [new PopButtonData(Contents.lang.t[id_submit],ButtonFrameYes,null,true,true)
				,new PopButtonData(Contents.lang.t[id_back],ButtonFrameNo,null,true,true)] ;
			var popFields:PopMenuFields = new PopMenuFields();
			popFields.addField(tagLable,defaultTextOnField,keyboardType,isPassword,true,true);
			var popText:PopMenuContent = new PopMenuContent(question,popFields,buttons,innerDisplayObject);
			PopMenu1.popUp(title,null,popText,0,textCatched);
		}
		
			/**Text catched*/
			private static function textCatched(e:PopMenuEvent):void
			{
				switch(e.buttonTitle)
				{
					case Contents.lang.t[id_submit]:
					{
						if(onQuestionAccepted.length==0)
							onQuestionAccepted()
						else
							onQuestionAccepted(e);
						break;
					}
						
					default:
					{
						if (onNotAccepted != null)
						{
						if (onNotAccepted.length == 0)
							onNotAccepted()
						else
							onNotAccepted(e);
						}
						break;
					}
				}
			}
		
		private static function onQuestionAnswered(e:PopMenuEvent)
		{
			if(e.buttonTitle == Contents.lang.t[id_yes])
			{
				if(onQuestionAccepted.length>0)
				{
					onQuestionAccepted(e);
				}
				else
				{
					onQuestionAccepted();
				}
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
		public static function show(str:String,canselable:Boolean=true,delyTime:int=-1,displayObject:MovieClip=null,title:String='',onClose:Function=null,backButtonFrame:uint=1,backButtonTitle:String = ""):void
		{
			controllConfig();
			var buttons:Array ;
			_onClose = onClose;
			if(backButtonTitle=="")
			 backButtonTitle = Contents.lang.t[id_back]
			if(canselable)
			{
				buttons = [new PopButtonData(backButtonTitle,backButtonFrame)];
			}
			if(delyTime==-1)
			{
				delyTime = showTimer ;
			}
			var popText:PopMenuContent = new PopMenuContent(str,null,buttons,displayObject);
			PopMenu1.popUp(title,null,popText,delyTime,onShowCloseSelected,onShowCloseSelected);
		}
		private static function onShowCloseSelected(evnet:PopMenuEvent):void
		{
			if(_onClose!=null)
			{
				_onClose.call();
			}
		}
		
		/**Show no internet connection available*/
		public static function noInternet(fakeInput:*=null,onClosed:Function=null)
		{
			controllConfig();
			show(Contents.lang.t[id_no_internet],true,-1,null,'',onClosed);
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
			controllConfig();
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
		
		protected static var onSearched:Function,
							onSelected:Function,
							onBacked:Function;
		
		/**Select something from these buttons, but if the onSearchButtn function was not null, it will add search input to<br>
		 * onButtonSelected : function(e:PopMenuEvent);<br>
		 * onSearchButton : function(searchParam:String);<br>
		 * the function "onJobSelected" must have a variable based on PopMenuEvent */
		public static function selector(title:String,text:String,buttonsList:Array,onButtonSelected:Function,onSearchButton:Function=null,defButtonFrame:uint=1,itemFrame:uint=2,onBackFUnction:Function = null,backButtonFrame:int=1,addBackButton:Boolean=true):void
		{
			controllConfig();
			var moreHint:String = '' ;
			var namesArray:Array ;
			var popField:PopMenuFields = new PopMenuFields();
			
			onSearched = onSearchButton ;
			onSelected = onButtonSelected ;
			onBacked = onBackFUnction ;
			
			var backButton:PopButtonData = new PopButtonData(Contents.lang.t[id_back],backButtonFrame,null,true,true);
			
			if( onSearched != null )
			{
				if(addBackButton)
				{
					namesArray = [new PopButtonData(Contents.lang.t[id_search],1,null,true,true),backButton,''] ;
				}
				else
				{
					namesArray = [Contents.lang.t[id_search],''] ;
				}
			}
			else
			{
				if(addBackButton)
				{
					namesArray = [backButton,''] ;
				}
				else
				{
					namesArray = [] ;
				}
			}
			namesArray = namesArray.concat(buttonsList);
			SaffronLogger.log("namesArray : "+namesArray.length);
			
			if((addBackButton && namesArray.length < 3) || (!addBackButton && namesArray.length == 0 ))
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
				SaffronLogger.log("let this menu close");
				if(onBacked!=null)
				{
					if(onBacked.length==0)
						onBacked();
					else
						onBacked(null);
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
			controllConfig();
			
			myPreLoader = preLoaderMC ;
		}
		
		public static function controlLanguages():void
		{
			controllConfig();
			if(Contents.lang.t[id_submit]==undefined)
			{
				throw "Add below tag to language.xml\n\n\t<id_submit>\n\t\t<fa>ثبت</fa>\n\t</id_submit>\n\n\n";
			}
		}
	}
}