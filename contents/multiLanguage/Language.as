package contents.multiLanguage
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class Language
	{
		private var _isArabic:Boolean = false,
					_rtl:Boolean = false ;
					
		/**This will tells you that you have to convert texts or not*/	
		public function get isArabic():Boolean
		{
			return _isArabic ;
		}
			
		public function get id():String
		{
			return currentLang;
		}
		
		public function get rtl():Boolean
		{
			return _rtl ;
		}
		
		
		public const EVENT_TEXT_RESIZED:String = "EVENT_TEXT_RESIZED";
		
		public const IM_READY_EVENT:String = "IM_READY_EVENT";
		
		/*******/
		private static const debug_manage_font_size_on_tablet:Boolean = false ;
		
		public var langDispatcher:EventDispatcher = new EventDispatcher();
		
		/**I dont have these function to increase font sizes now*/
		private const increasedSize:Number=10,
			increasedHeight:Number=10;
		
		private const DATAS:String = "DATAS";
		
		private var myDatas:Object = {};
		
		
		private var loadedXML:XML,
					movXML:XML,
					textXML:XML,
					fontSwitch:XML,
					
					currentLang:String,
					
					myStage:Stage;
		
		/**this object will have all texts in its tag name on its variabes*/			
		public var t:Object = new Object();
		
		/**controll the added items*/
		private var addedItems:Array = [],
			itemRemover:Timer;
		
		/**Use the lang value on it to detect last selected language*/
		private var lastSavedLang:SharedObject = SharedObject.getLocal("lastSavedLanguage",'/');
		
		/**Call setUp function to start its work.*/
		public function Language():void
		{
		}
		
		public function setUp( languageFile:String = 'language.xml', mystage:Stage = null )
		{
			myStage = mystage ;
			
			var xmlTarget:File = File.applicationDirectory.resolvePath(languageFile);
			var fileLoader:FileStream = new FileStream();
			fileLoader.open(xmlTarget,FileMode.READ);
			var str:String = fileLoader.readUTFBytes(fileLoader.bytesAvailable);
			loadedXML = XML(str);
			movXML = loadedXML.movieclips[0];
			textXML =  loadedXML.texts[0];
			fontSwitch = loadedXML.fonts_switch[0];
			/*currentLang = loadedXML.currentlang;*/
			
			if(lastSavedLang.data.lang == undefined)
			{
				changeLanguage(loadedXML.currentlang);
			}
			else
			{
				changeLanguage(lastSavedLang.data.lang);
			}
			/*
			for(var i = 0 ; i<textXML.*.length() ; i++)
			{
				t[textXML.*[i].localName()] = textXML.*[i][currentLang];
			}*/
			
			
			myStage.addEventListener(Event.ADDED,itemIsAdded);
			
			
			langDispatcher.dispatchEvent(new Event(IM_READY_EVENT));
			
			
			itemRemover = new Timer(1000);
			itemRemover.addEventListener(TimerEvent.TIMER,resetifitsGone);
		}
		
		/**Returns true if this language is defined.*/
		public function hasThisLangID(langID:String):Boolean
		{
			return loadedXML.language_info.hasOwnProperty(langID);
		}
		
		/**Change the last language - this will update all interfaces to*/
		public function changeLanguage(languageID:String)
		{
			addedItems = new Array();
			
			
			lastSavedLang.data.lang = loadedXML.currentlang = currentLang = languageID ;
			lastSavedLang.flush();
			
			for(var i = 0 ; i<textXML.*.length() ; i++)
			{
				t[textXML.*[i].localName()] = textXML.*[i][currentLang];
				//trace("t[textXML.*[i].localName()] : "+t[textXML.*[i].localName()]);
			}
			
			var arabic:String = loadedXML.language_info[currentLang].@arabic ;
			var rtl_:String = loadedXML.language_info[currentLang].@rtl ;
			
			if( arabic == '0' || arabic == null || arabic == '' )
			{
				_isArabic = false ;
			}
			else
			{
				_isArabic = true ;
			}
			
			if(rtl_ == '0' || rtl_==null || rtl_=='')
			{
				_rtl = false ;
			}
			else
			{
				_rtl = true ;
			}
			
			UnicodeStatic.deactiveConvertor = !_isArabic ;
			manageAll(myStage);
		}
		
		
		
		/*public function load(mystage:Stage)
		{
			//myStage = mystage ;
			var xmlTarget:File = File.applicationDirectory.resolvePath('language.xml');
			var fileLoader:FileStream = new FileStream();
			fileLoader.open(xmlTarget,FileMode.READ);
			var str:String = fileLoader.readUTFBytes(fileLoader.bytesAvailable);
			loadedXML = XML(str);
			movXML = loadedXML.movieclips[0];
			textXML =  loadedXML.texts[0];
			fontSwitch = loadedXML.fonts_switch[0];
			currentLang = loadedXML.currentlang;
			
			for(var i = 0 ; i<textXML.*.length() ; i++)
			{
				t[textXML.*[i].localName()] = textXML.*[i][currentLang];
			}
			
			myStage.addEventListener(Event.ADDED,itemIsAdded);
			manageAll(myStage);
			
			langDispatcher.dispatchEvent(new Event(IM_READY_EVENT));
			
			
			itemRemover = new Timer(1000);
			itemRemover.addEventListener(TimerEvent.TIMER,resetifitsGone);
		}*/
		
		/**reset the added items list if its objects removed from stage*/
		private function resetifitsGone(e:TimerEvent)
		{
			for(var i = 0 ; i <addedItems.length ; i++)
			{
				if(DisplayObject(addedItems[i]).stage == null)
				{
					addedItems.splice(i,1);
					i--;
				}
			}
			
			for(i in myDatas)
			{
				if(i is DisplayObject && DisplayObject(i).stage == null)
				{
					myDatas[i] = undefined ;
				}
			}
		}
		
		/*public function get isArabic():Boolean
		{
			if(currentLang=='en')
			{
				return false ;
			}
			else
			{
				return true ;
			}
		}*/
		
		
		
		public function manageAll(targ:DisplayObjectContainer)
		{
			for(var i = 0  ; i<targ.numChildren ; i++)
			{
				var targ2:* = targ.getChildAt(i);
				if(targ2 is DisplayObjectContainer)
				{
					(targ2 as DisplayObject).dispatchEvent(new Event(Event.ADDED,true));
					manageAll(targ2);
				}
				if(targ2 is TextField)
				{
					(targ2 as TextField).dispatchEvent(new Event(Event.ADDED,true));
				}
			}	
		}
		
		public function MangeItem(Targ:*)
		{
			if(Targ is MovieClip || Targ is TextField)
			{
				itemIsAdded(Targ);
			}
		}
		
		/**this object is added to stage*/
		private function itemIsAdded(e:*)
		{
			var targ:* ;
			if(e is Event)
			{
				targ = e.target ;
			}
			else
			{
				targ = e ;
			}
			
			//trace('some thing added : '+targ);
			if(targ is MovieClip)
			{
				if(addedItems.indexOf(targ)==-1)
				{
					var founded:* = movXML[targ.name] ;
					if(String(founded) != '')
					{
						MovieClip(targ).gotoAndStop(uint(founded[currentLang]));
						addedItems.push(targ);
					}
					//New line
					manageAll(targ as DisplayObjectContainer);
				}
			}
			else if(targ is TextField)
			{
				if(addedItems.indexOf(targ)==-1)
				{
					//trace("Manage this text : "+(targ as TextField).getBounds(myStage)+' : '+(targ as TextField).text);
					var tf:TextFormat = (targ as TextField).defaultTextFormat ;
					var mydisp:DisplayObject = targ as DisplayObject;
					
					/**Add this later*/
					if(debug_manage_font_size_on_tablet && !DevicePrefrence.isTablet)
					{
						///Add this later
						var lastSize:Object = myDatas[targ];
						//trace('last size is : '+lastSize);
						if(lastSize == null)
						{
							lastSize = myDatas[targ] = tf.size	;
						}
						else
						{
							trace('object founds');
						}
						//trace('font size increased');
						tf.size = lastSize+increasedSize;
						TextField(targ).height+=increasedHeight;
						TextField(targ).y-=increasedHeight/2;
					}
					var direction:String = tf.align ;
					var font:String = tf.font.toLocaleLowerCase();
					var bold:String = String(tf.bold) ;
					//trace("And its font name is : "+font);
					for(var i = 0 ; i<fontSwitch.font.length() ; i++)
					{
						var curXML:XML = fontSwitch.font[i][currentLang][0] ;
						if(!isNull(curXML))
						{
							var xmlFontName:String = String(curXML.from.@name).toLocaleLowerCase();
							var xmlBoldState:String = String(curXML.from.@bold) ;
							//trace("xmlFontName == font && xmlBoldState == String(bold) : "+xmlFontName+' == '+font+' && '+xmlBoldState+' == '+String(bold));
							if(xmlFontName == font && xmlBoldState == String(bold) )
							{
								//trace("So i have to change its font");
								if(isArabic && direction == TextAlign.LEFT)
								{
									tf.align = TextAlign.RIGHT;
								}
								else if(!isArabic && direction == TextAlign.RIGHT)
								{
									tf.align = TextAlign.LEFT;
								}
								
								var xmlFontTo:String = String(curXML.to.@name);
								var xmlBoldStage:Boolean = (String(curXML.to.@bold)=='true')?true:null;
								tf.font = xmlFontTo ;
								if(xmlBoldStage == true)
								{
									tf.bold = xmlBoldState ;
								}
								//(targ as TextField).defaultTextFormat = tf ;
								//(targ as TextField).setTextFormat(tf) ;
								(targ as TextField).embedFonts = true ;
							}
						}	
					}
					addedItems.push(targ);
					
					//New Function to controll posible bugs.
					//trace("*** required font is : "+tf.font+' > '+(targ as TextField).text);
					var removeText:Boolean = false ;
					if((targ as TextField).text=='')
					{
						(targ as TextField).text = '-';
						removeText = true ;
					}
					(targ as TextField).defaultTextFormat = tf ;
					(targ as TextField).setTextFormat(tf) ;
					if(removeText)
					{
						(targ as TextField).text = '' ;
					}
					//trace("*** final font is : "+(targ as TextField).defaultTextFormat.font+' > '+(targ as TextField).text);
					(targ as DisplayObject).dispatchEvent(new Event(EVENT_TEXT_RESIZED));
				}
			}
			
		}
		
		/**detect if xml is null*/
		private function isNull(xml:XML):Boolean
		{
			if(String(xml) == '' || String(xml) == 'null')
			{
				return true;
			}
			else
			{
				return false ;
			}
		}
	}
}