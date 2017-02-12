package PopButtonCreator
{
	import contents.TextFile;
	
	import flash.filesystem.File;
	
	import popForm.PopButtonData;
	
	/**<item name="" id=""/>
	 * <item name="" id=""/>
	 * <item name="" id=""/>
	 * <item name="" id=""/>*/
	public class GlobalButtonCreator
	{
		
		private var countriesXML:XMLList ;
		private var buttons:Array,
					titles:Array,
					ids:Array;
		
		/**<item name="" code=""/>
		 * <item name="" code=""/>
		 * <item name="" code=""/>
		 * <item name="" code=""/>*/
		public function GlobalButtonCreator(xmlTarget:String,buttonFrame:uint=2,sort:Boolean=true)
		{
			countriesXML = XMLList(TextFile.load(File.applicationDirectory.resolvePath(xmlTarget)));
			buttons = new Array();
			titles = new Array();
			ids = new Array();
			for(var i = 0 ; i<countriesXML.length();i++)
			{
				var name:String = countriesXML[i].@name ;
				var code:String = countriesXML[i].@code ;
				if(name == null || name == '')
				{
					name = code ;
				}
				if(code == null || code == '')
				{
					code = name ;
				}
				titles.push(name);
				ids.push(code);
				var newCountry:PopButtonData = new PopButtonData(name,buttonFrame,code);
				buttons.push(newCountry);
			}
			if(sort)
			{
				buttons.sortOn("title");
			}
		}
		
		/**Returns a random PopButtonData from the buttons list*/
		public function randomButton():PopButtonData
		{
			return buttons[Math.floor(Math.random()*buttons.length)];
		}
		
		public function titlesList():Array
		{
			return titles.concat();
		}
		
		public function idList():Array
		{
			return ids.concat();
		}
		
		public function buttonsList():Array
		{
			return buttons.concat() ;
		}
	}
}