package filter
{//filter.FilterAnimate
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class FilterAnimate extends MovieClip
	{
		private var _id:int;
		private var filterItemMc:MovieClip
		public var totalItems:int=1;
		private var _fun:Function;
		private var _title:MovieClip;
		private var _backGroundColor:MovieClip;
		public function FilterAnimate()
		{
			super();
			filterItemMc = Obj.get('filterItem_mc',this)	
			this.addEventListener(MouseEvent.MOUSE_DOWN,selected)	
		}
		
		protected function selected(event:MouseEvent):void
		{
			
			_fun(_id)					
		}
		public function setup(Id_p:int,Fun_p:Function=null,OldId_p:int=-1):void
		{
			_id = Id_p
			_fun = Fun_p	
			if(filterItemMc!=null)
			{
				filterItemMc.gotoAndStop(Id_p)
				_title = Obj.get('title_mc',filterItemMc)
				_backGroundColor = Obj.get('backGroundColor_mc',filterItemMc)
				if(_backGroundColor!=null)
				{
					if(_id==OldId_p)
					{
						_backGroundColor.gotoAndStop(true)
					}
					else
					{
						_backGroundColor.gotoAndStop(false)
					}
				}
				totalItems = filterItemMc.totalFrames	
			}
		}
		public function setTitle(Status_p:Boolean):void
		{
			if(_title!=null)
			{
				_title.visible = Status_p
			}
			if(_backGroundColor!=null)
			{
				_backGroundColor.gotoAndStop(Status_p)
			}
		}
	}
}