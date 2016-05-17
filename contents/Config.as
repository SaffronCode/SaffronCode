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
		
		public var debugStageHeight:Number = 0 ;
		public var debugStageWidth:Number = 0 ;
		
		public var internal_menu_height_top:Number = 0 ;
		
		public var internal_menu_height_bottom:Number = 0 ;
		
		public var internal_menu_width_left:Number = 0 ;
		
		public var internal_menu_width_right:Number = 0 ;
		
		public var skipAnimations:Boolean = false ;
		
		public var version_controll_url:String = "http://sarkandi.com/versionControl/"
		
		
		//Reserved valuse
		
		private var _stageRect:Rectangle = new Rectangle() ;
		
		private var _stageOrgiginalRect:Rectangle = new Rectangle();
		
		
		public function Config()
		{
			trace("Config starts");
		}
		
		public function set stageOrgRect(value:Rectangle):void
		{
			if(_stageOrgiginalRect.width == 0)
			{
				trace("Staage size set on Config");
				_stageOrgiginalRect = value.clone();
			}
			else
			{
				trace("Stage size cannot change on Config");
			}
		}
		
		public function get deltaStageRect():Rectangle
		{
			return new Rectangle(0,0,_stageRect.width-_stageOrgiginalRect.width,_stageRect.height-_stageOrgiginalRect.height);
		}
		
		public function get stageOrgRect():Rectangle
		{
			return _stageOrgiginalRect.clone();
		}
		
		/**This is absolute rectangle and the x and y are 0*/
		public function get stageRect():Rectangle
		{
			return _stageRect.clone();
		}
		
		/**You can repose the stage items by this rectangle. the x and y values shows how much you should move your item on the stage*/
		public function get stageMovedRect():Rectangle
		{
			return new Rectangle((_stageRect.width-_stageOrgiginalRect.width)/-2,(_stageRect.height-_stageOrgiginalRect.height)/-2,_stageRect.width,_stageRect.height);
		}

		public function set stageRect(value:Rectangle):void
		{
			trace("Stage rectangle updated on config class");
			_stageRect = value.clone();
		}
		
		/**Creats a page rectangle from the config file*/
		public function get pageRect():Rectangle
		{
			return new Rectangle(internal_menu_width_left,internal_menu_height_top,_stageRect.width-(internal_menu_width_left+internal_menu_width_right),_stageRect.height-(internal_menu_height_top+internal_menu_height_bottom));
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
					trace("Custom value is : "+varVal+" with the name of : "+varName);
					var val:Number;
					if(!isNaN(Number(varVal)))
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
					else if(String(varVal).indexOf('0x')==0 && !isNaN(val = parseInt(varVal,16)))
					{
						this[varName] = val ;
					}
					else
					{
						this[varName] = String(varVal);
					}
				}
			}
			
			if(isNaN(debugStageHeight))
			{
				debugStageHeight = 0 ;
			}
			if(isNaN(debugStageWidth))
			{
				debugStageWidth = 0 ;
			}
		}
	}
}