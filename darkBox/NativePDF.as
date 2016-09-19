package darkBox
{
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;

	internal class NativePDF
	{
		/**Native pdf loader*/
		private static var 	PDFReaderClass:Class,
							PDFReaderSupports:int = -1 ;
							
		private static var pdfReaderInstant:* ;
		
		public static function isSupports():Boolean
		{
			setUp();
			if(PDFReaderSupports==1)
			{
				return true ;
			}
			else
			{
				return false ;
			}
		}
		
		/**Call this function first*/
		public static function setUp():void
		{
			if(PDFReaderSupports==-1)
			{
				try
				{
					PDFReaderClass = getDefinitionByName("com.janumedia.ane.pdfreader.PDFReader") as Class ;
					pdfReaderInstant = new PDFReaderClass();
					PDFReaderSupports = 1 ;
				}
				catch(e)
				{
					PDFReaderClass = null ;
					PDFReaderSupports = 0 ;
				};
			}
		}
		
		public static function openPDFReader(pdfFile:File):void
		{
			if(isSupports())
			{
				if(pdfReaderInstant.hasPDFApplication(pdfFile))
				{
					trace("PDF is loaded");
				}
				else
				{
					trace("Use has no PDF reader");
					navigateToURL(new URLRequest("market://delails?id=com.adobe.reader"));
				}
			}
			else
			{
				throw "PDF reader is not supporting" ;
			}
		}
	}
}