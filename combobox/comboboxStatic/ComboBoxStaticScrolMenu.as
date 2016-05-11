package combobox.comboboxStatic
{//combobox.comboboxStatic.ComboBoxStaticScrolMenu
	import avmplus.getQualifiedClassName;
	
	import contents.PageData;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	public class ComboBoxStaticScrolMenu extends MovieClip
	{
		private var _comboBoxDynamicItem:ComboBoxDynamicItem;
		private var _y:Number = 0
			
		private var _linkClass:Class;
		private var removeArray:Array = new Array()
		public function ComboBoxStaticScrolMenu()
		{
			super();
			_comboBoxDynamicItem = Obj.findThisClass(ComboBoxDynamicItem,this)
					
			if(_comboBoxDynamicItem!=null)
			{
				_comboBoxDynamicItem.visible = false
				_linkClass = getDefinitionByName(getQualifiedClassName(_comboBoxDynamicItem)) as Class;
			}
			else if(_comboBoxDynamicItem==null)
			{
				trace("Dynamic manu class shouldent be empty of linkItem!");
			}
			
			setScrol()
		}
		public function setup(PageData_p:PageData=null):void
		{

			removeList()
			if(PageData_p!=null && _comboBoxDynamicItem!=null)
			{			
				for(var i:int=0;i<PageData_p.links1.length;i++)
				{		
					
					var _item:ComboBoxDynamicItem = new _linkClass()
						this.addChild(_item)
						removeArray.push(_item)	
						_item.addItem(PageData_p.links1[i])
							_item.y = _y
							_y+=_item.height+ComboBoxStaticManager.dynamicLinkY	
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
		private function removeList():void
		{
			for(var i:int=0;i<removeArray.length;i++)
			{
				this.removeChild(removeArray[i])
			}
			removeArray = new Array()
			_y = 0	
		}
	}
}