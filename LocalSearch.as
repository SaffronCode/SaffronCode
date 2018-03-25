package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import popForm.PopField;
	
	public class LocalSearch extends MovieClip
	{
		private var _searchTitle:PopField;
		private var _serachFun:Function;
		private var _closeBtn:MovieClip;
		private var _icon:MovieClip;
		public function LocalSearch()
		{
			super();
			_searchTitle = Obj.findThisClass(PopField,this);
			_closeBtn = Obj.get('closeBtn_mc',this);
			_icon = Obj.get('icon_mc',this);
		}
		public function setup(SerachFun_fun:Function,title:String=''):void
		{
			_serachFun = SerachFun_fun;
			_searchTitle.setUp('',title);
			_searchTitle.addEventListener(Event.CHANGE,change);
			_closeBtn.addEventListener(MouseEvent.CLICK,closeSerach);
			_closeBtn.visible = false;
			chekText();
		}
		
		protected function closeSerach(event:MouseEvent):void
		{
			_searchTitle.text = '';
		}
		private function chekText():void
		{
			_closeBtn.visible = _searchTitle.text !=null && _searchTitle.text!='';	
			_icon.visible = !_closeBtn.visible;
		}
		protected function change(event:Event):void
		{
			chekText();
			_serachFun(_searchTitle.text);
		}
		public function close():void
		{
			closeSerach(null);
		}
	}
}