package PopButtonCreator
{
	import contents.TextFile;
	
	import flash.filesystem.File;
	
	import popForm.PopButtonData;

	public class CountryList
	{
		private static var countriesXML:XMLList ;

		private static var buttons:Array;
		
		public static function setUp(xmlTarget:String="Data/countries.xml",buttonFrame:uint=2):void
		{
			countriesXML = XMLList(TextFile.load(File.applicationDirectory.resolvePath(xmlTarget)));
			buttons = new Array();
			for(var i = 0 ; i<countriesXML.length();i++)
			{
				var newCountry:PopButtonData = new PopButtonData(countriesXML[i].@name,buttonFrame,String(countriesXML[i].@code));
				buttons.push(newCountry);
			}
			buttons.sortOn("title");
		}
		
		public static function countrieButtons():Array
		{
			
			return buttons ;
		}
	}
}