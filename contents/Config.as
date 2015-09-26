package contents
{
	import flash.filesystem.File;
	import flash.geom.Rectangle;

	dynamic public class Config
	{
		
		//Default values
		public var domain:String ='' ;
		
		public var wsdl:String = '';
		
		public var maximomStageWidth:Number = 0 ;
		
		public var maximomStageHeight:Number = 0;
		
		public var 	debug1:Boolean=false,
					debug2:Boolean=false,
					debug3:Boolean=false,
					debug4:Boolean=false;
		
		public var internal_menu_height_top:Number = 0 ;
		
		public var internal_menu_height_bottom:Number = 0 ;
		
		
		//Reserved valuse
		
		private var _stageRect:Rectangle = new Rectangle() ;
		
		
		public function Config()
		{
			trace("Config starts");
		}
		
		public function get stageRect():Rectangle
		{
			return _stageRect.clone();
		}

		public function set stageRect(value:Rectangle):void
		{
			trace("Stage rectangle updated on config class");
			_stageRect = value.clone();
		}
		
		/**Creats a page rectangle from the config file*/
		public function get pageRect():Rectangle
		{
			return new Rectangle(0,internal_menu_height_top,_stageRect.width,_stageRect.height-(internal_menu_height_top+internal_menu_height_bottom));
		}

		public function load(configURLFile:String):void
		{
			var loadedXMLString:String = TextFile.load(File.applicationDirectory.resolvePath(configURLFile));
			var xml:XML = XML(loadedXMLString);
			
			for(var i = 0 ; i<xml.*.length() ; i++)
			{
				var varName:String = String(xml.*[i].localName()) ;
				var varVal:String = String(xml.*[i]);
				if(this.hasOwnProperty(varName))
				{
					if(this[varName] is Number)
					{
						this[varName] = Number(varVal) ;
					}
					else if(this[varName] is Boolean)
					{
						this[varName] = (varVal!=null && varVal!='')?true:false;
						if(varVal.toLowerCase() == "false")
						{
							this[varName] = false ;
						}
					}
					else if(this[varName] is Rectangle)
					{
						trace("Rectangle values cannot be overriten by config xml");
					}
					else
					{
						this[varName] = varVal ;
					}
				}
				else
				{
					if(isNaN(Number(varVal)))
					{
						this[varName] = Number(varVal);
					}
					else if(String(varVal).toLowerCase() == 'true')
					{
						this[varName] = true ;
					}
					else if(String(varVal).toLowerCase() == 'false')
					{
						this[varName] = false ;
					}
					else
					{
						this[varName] = String(varVal);
					}
				}
			}
		}
	}
}