package popForm
	//popForm.PopFieldBoolean
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import animation.Anim_Frame_Controller;

	/**Boolean field changed*/
	[Event(name="change", type="flash.events.Event")]
	public class PopFieldBoolean extends PopFieldInterface
	{
		public var tagTF:TextField;
		
		private var checkMC:MovieClip ;
		private var backMC:MovieClip;

		private var checkAnimation:Anim_Frame_Controller ;
		private var lastCheckStatus:Boolean ;
		
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
		
		private function switchBoolean(e:*):void
		{
			lastCheckStatus = !lastCheckStatus ;
			checkIt(lastCheckStatus);
			this.dispatchEvent(new Event(Event.CHANGE));
		}

		private function checkIt(status:Boolean):void
		{
			if(checkAnimation!=null)
			{
				checkAnimation.gotoFrame(status==true?checkMC.totalFrames:1);
			}
			else
			{
				checkMC.visible = status ;
			}
		}
		
		public function setUp(tagName:String,defaultState:Boolean=false,isArabic:Boolean=true,languageFrame:uint=1,color:uint=1):void
		{
			IsArabic = isArabic ;
			
			myTitle = tagName ;
			
			this.gotoAndStop(languageFrame);
			
			backMC = Obj.get("back_mc",this);
			backMC.stop();
			changeColor(color);
					
			var tagContainer:MovieClip = Obj.getAllChilds("tag_txt",this,true)[0];
			tagTF = Obj.getAllChilds("tag_txt",tagContainer,true)[0];
			checkMC = Obj.get("check_mc",this);
			if(checkMC.totalFrames>1)
			{
				checkAnimation = new Anim_Frame_Controller(checkMC,1,false);
			}
			
			TextPutter.OnButton(tagTF,tagName,isArabic,true,false);
			
			update(defaultState);
		}
		
		public function changeColor(colorFrame:uint):void
		{
			backMC.gotoAndStop(colorFrame);
		}
		
		override public function update(data:*):void
		{
			lastCheckStatus = data ;
			checkIt(data);
		}
		
		override public function get title():String
		{
			return myTitle ;
		}
		
		override public function get data():*
		{
			//SaffronLogger.log("Get my date : "+date);

			return lastCheckStatus ;
		}
		
		public function set data(value:Boolean):void
		{
			lastCheckStatus = value ;
			checkIt(lastCheckStatus);
		}
	}
}