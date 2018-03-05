package nativeClasses.pdfReader
{
	
	import flash.display.Sprite;
	
	import permissionControlManifestDiscriptor.PermissionControl;
	
	public class DistriqtPDFReader extends Sprite
	{
		public static function setUp(DistriqtId:String):void
		{
			var requiredNatives:Array = [	"com.distriqt.PDFReader",
											"com.distriqt.Core",
											"com.distriqt.androidsupport.V4"];
			
			var nativesToAdd:String = '' ;
			
			for(var i:int = 0 ; i<requiredNatives.length ; i++)
			{
				var check:String = PermissionControl.checkTheNativeLibrary(requiredNatives[i]) ; 
				if(check!='')
				{
					nativesToAdd+=check+'\n';
				}
			}
			
			if(nativesToAdd!='')
			{
				trace("******* You should add below extentions to your project for PDF to work\n\n\n"+nativesToAdd+"\n\n\n*********************");
			}
		}
		
		public function DistriqtPDFReader()
		{
			super();
		}
	}
}