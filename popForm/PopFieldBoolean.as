package popForm
	//popForm.PopFieldBoolean
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**Boolean field changed*/
	[Event(name="change", type="flash.events.Event")]
	public class PopFieldBoolean extends PopFieldInterface
	{
		public var tagTF:TextField;
		
		private var checkMC:MovieClip ;
		private var backMC:MovieClip;
		
		private var IsArabic:Boolean,
					myTitle:String;
		
		public function PopFieldBoolean(tagName:String=null,defaultState:Boolean=false,isArabic:Boolean=true,languageFrame:uint=1,color:uint=1)
		{
			super();
			
			this.addEventListener(MouseEvent.CLICK,switchBoolean);
			
			if(tagName!=null)
			{
				setUp(tagName,defaultState,isArabic,languageFrame,color);
			}
		}
		
		private function switchBoolean(e):void
		{
			checkMC.visible = !checkMC.visible ;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setUp(tagName:String,defaultState:Boolean=false,isArabic:Boolean=true,languageFrame:uint=1,color:uint=1):void
		{
			IsArabic = isArabic ;
			
			myTitle = tagName ;
			
			this.gotoAndStop(languageFrame);
			
			backMC = Obj.get("back_mc",this);
			backMC.stop();
			changeColor(color);
			
			tagTF = Obj.get("tag_txt",Obj.get("tag_txt",this));
			checkMC = Obj.get("check_mc",this);
			
			TextPutter.OnButton(tagTF,tagName,isArabic,true,false);
			
			update(defaultState);
		}
		
		public function changeColor(colorFrame:uint)
		{
			backMC.gotoAndStop(colorFrame);
		}
		
		override public function update(data:*):void
		{
			checkMC.visible = data ;
		}
		
		override public function get title():String
		{
			return myTitle ;
		}
		
		override public function get data():*
		{
			//trace("Get my date : "+date);
			return checkMC.visible ;
		}
		
		public function set data(value:Boolean):void
		{
			checkMC.visible = value ;
		}
	}
}