package simpelComboBox
{//simpelComboBox.SimpelComboBox
	import appManager.displayContentElemets.TitleText;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import popForm.Hints;
	import popForm.PopButtonData;
	import popForm.PopMenuEvent;
	
	public class SimpelComboBox extends MovieClip
	{
		public var Item:SimpelComboBoxListItem;
		private var onSeletItem:Function;
		private var list:Array;
		private var _title:String;
		private var _titleText:TitleText;
		private var _defualtIndex:int;
		private var _splitTitle:Boolean;
		public function SimpelComboBox()
		{
			super();
			_titleText = Obj.findThisClass(TitleText,this);
			
		}
		
		protected function openList(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			Hints.selector(_title,'',list,selector);
		}
		public function setup(title_p:String,list_p:Array,onSeletITemFun_p:Function,runFunctionOnSetup:Boolean=true,splitTitle:Boolean=false,defualtIndex:int=0):void
		{
			Item = new SimpelComboBoxListItem();
			onSeletItem = onSeletITemFun_p;
			list = list_p;
			_defualtIndex = defualtIndex;
			_splitTitle = splitTitle;
			_title = title_p
			this.addEventListener(MouseEvent.CLICK,openList)
			if(list_p.length>0)
			{
				if(_titleText!=null)
				{
					_titleText.addEventListener(Event.ADDED_TO_STAGE,titleAddToStage);	
				}
				Item.Id = list_p[0].id;
				Item.Title = list_p[0].title;
				if(runFunctionOnSetup)
				{
					onSeletItem();
				}
			}
		}
		
		protected function titleAddToStage(event:Event):void
		{
			_titleText.setUp(list[_defualtIndex].title,true,_splitTitle);	
		}
		
		private function selector(event:PopMenuEvent):void
		{	
			Item.Id = event.buttonID;
			Item.Title = event.buttonTitle;	
			onSeletItem();
			_titleText.setUp(event.buttonTitle)
		}
	}
}