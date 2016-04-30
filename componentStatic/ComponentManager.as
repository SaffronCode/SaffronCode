package componentStatic
{
	import com.mteamapp.JSONParser;
	
	import flash.display.MovieClip;
	
	
	public class ComponentManager extends MovieClip
	{
		private static var _catcherObject:Object = new Object();
		private static var _obj:Object= new Object();
		public static var evt:ComponentManager;

			
		private static var _page:String;
		private var errorManager:ErrorManager;
		
		protected var filedCorrectMc:MovieClip;
		public function ComponentManager()
		{	
			errorManager = new ErrorManager()
			filedCorrectMc = Obj.get('filedCorrect_mc',this)	
		}
		public function setup(CatcherObject:*,Page_p:String,IgnoreList_p:Array=null,DefultValue_p:*=null)
		{
			evt = this
			errorManager.setup()
			_page = Page_p
			_catcherObject[_page] = CatcherObject
			if(IgnoreList_p!=null)
			{
				ErrorManager.ignoreList = IgnoreList_p
				trace('ingnoreList :',JSON.stringify(ErrorManager.ignoreList))	
			}
			else
			{
				ErrorManager.ignoreList = new Array()
			}
			if(_obj[_page]==null)
			{
				_obj[_page] =  new Object()
			}
			
			var copyCatcherObject:Object = JSON.parse(JSON.stringify(DefultValue_p))	
			if(DefultValue_p!=null)
			{
				_obj[_page] = copyCatcherObject
			}
			setCatacher()					
		}
		protected function setObj(Name_p:String,Value:*,Type_p:String='')
		{
			if(_obj[_page]!=null)
			{
				_obj[_page][Name_p] = Value
			}
			if(Value is Array && _catcherObject[_page]!=null)
			{
				_catcherObject[_page][Name_p] = new Array()
			}
			setCatacher()
			
			var _selectFieldData:Object;
			
			
			
			if(_catcherObject[_page]!=null)
			{
				_selectFieldData = JSON.parse(JSON.stringify(_catcherObject[_page]))
			}
			else
			{
				_selectFieldData = _obj[_page]
			}	
			evt.dispatchEvent(new ComponentManagerEvent(ComponentManagerEvent.CHANG,Name_p,Type_p))
			error(errorManager.chekError(_selectFieldData,Name_p,Type_p))	
		}
		private function setCatacher():void
		{
			JSONParser.parse(JSONParser.stringify(_obj[_page]),_catcherObject[_page])		
		}
		protected function getObj(Name_p:String):*
		{	if(_obj[_page]!=null)
			{
				return _obj[_page][Name_p]
			}
			trace('Component Manager is not setup ')
			return null
		}
		public function obj():*
		{
			return _catcherObject[_page]
		}
		protected function error(Error_p:Boolean):void
		{
			if(filedCorrectMc!=null )
			{
				filedCorrectMc.visible = Error_p										
			}				
		}
		public function get errorlist():Vector.<ErrorItem>
		{	
			return errorManager.getError()
		}
	}
}