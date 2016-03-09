package combobox.comboboxStatic
{//combobox.comboboxStatic.ComboBoxStaticScrolMenu
	import contents.PageData;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class ComboBoxStaticScrolMenu extends MovieClip
	{
		private var _comboBoxDynamicItem:ComboBoxDynamicItem;
		private var _y:Number = 0
		public function ComboBoxStaticScrolMenu()
		{
			super();
			_comboBoxDynamicItem = Obj.findThisClass(ComboBoxDynamicItem,this)
			if(_comboBoxDynamicItem!=null)
			{
				_comboBoxDynamicItem.visible = false
			}
			setScrol()
		}
		public function setup(PageData_p:PageData=null):void
		{
			if(PageData_p!=null)
			{			
				for(var i:int=0;i<PageData_p.links1.length;i++)
				{		
					
					var _item:ComboBoxDynamicItem = new ComboBoxDynamicItem()
						this.addChild(_item)
						_item.addItem(PageData_p.links1[i])
							_item.y = _y
							_y+=_item.height	
				}				
			}
			setScrol()
		}
		
		private function setScrol():void
		{
			var _h:Number = Number(this.name.split(ComboBoxStaticManager.scrolSplit)[1])
			if(!isNaN(_h) && _h!=0)
			{				
				var _rec1:Rectangle = new Rectangle(this.x,this.y,this.width,_h)
				var _rec2:Rectangle = new Rectangle(0,0,this.width,this.height)
				var scrol:ScrollMT = new ScrollMT(this,_rec1,_rec2)
			}
		}
	}
}