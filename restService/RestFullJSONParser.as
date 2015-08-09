package restService
{
	
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	

	/**All vectors, Arrays and Objects had to be initialized on the main class and all values had to be in public type.*/
	internal class RestFullJSONParser
	{
		
		private static const mydateIndex:String = "myDateMESDateMineMineMESepehrMineDateBegin(";
		private static const mydateEnd:String = "myDateMESDateMineMineMESepehrMineDateEnd)";
		
		/**This stringiy will make server standard date on json*/
		public static function stringify(object:Object):String
		{
			var json:String = JSON.stringify(object,dateController);
			json = json.split(mydateIndex).join("\\/Date(").split(mydateEnd).join(")\\/");
			return json ;
		}
		
		private static function dateController(k,v):*
		{
			/**Sat Jun 13 16:45:04 GMT+0430 2015*/
			if(v is String && v!= null)
			{
				var V:String = v ;
				var vs:Array = V.split(' ');
				if(vs.length == 6)
				{
					if(String(vs[4]).indexOf('+')!=-1)
					{
						if(!isNaN(Number(vs[2])) && !isNaN(Number(vs[5])))
						{
							if(String(vs[3]).split(':').length==3)
							{
								//debug value;
									//return "2014/01/01";
								return mydateIndex+new Date(v).time+mydateEnd;
							}
						}
					}
				}
			}
			return v ;
		}
		
		
		public var error:Boolean = true  ;
		
		public var modelType:String = '';
		
		public var exceptionType:int ;
		
		public var msgs:Vector.<ClientMessageViewModel> = new Vector.<ClientMessageViewModel>();
		
		/**sample value
		public var numbers:Array = [];*/
		
		/**This is dynamic class*/
		public var model:* ;
		
		private var parsed:Object;
		
		
		/**Returns true if the json is paresd<br>
		 * serverData is unknown type , it can be json or byte array and its depend on fillThisObject type*/
		public function RestFullJSONParser(serverData:*/*,classType:Class*/,fillThisObject:Object)
		{
			if(fillThisObject is ByteArray)
			{
				trace("Type is byte array : "+getQualifiedClassName(serverData));
				try
				{
					//(fillThisObject as ByteArray).endian = Endian.LITTLE_ENDIAN ;
					(fillThisObject as ByteArray).writeBytes(serverData);
					trace("Byte length is : "+(fillThisObject as ByteArray).length);
					(fillThisObject as ByteArray).position = 0 ;
					error = false ;
				}
				catch(e)
				{
					trace("Byte array parse error ");
					exceptionType = ErrorEnum.BinaryError ;
				}
				return ;
			}
			else if(fillThisObject is Vector.<*>)
			{
				//Clear vector if it is full
				//trace("(model as Vector.<*>).length : "+(fillThisObject as Vector.<*>).length);
				while((fillThisObject as Vector.<*>).length)
				{
					(fillThisObject as Vector.<*>).pop();
				}
			}

			try
			{
				parsed = JSON.parse(serverData,reviver);
			}
			catch(e)
			{
				trace("JSON is not parsable");
				exceptionType = ErrorEnum.JsonParsProblem ;
			}
				//trace("classType : "+classType);
				//model = new classType() ;
			model = fillThisObject;
			//trace('1:'+avmplus.getQualifiedClassName(model));
			parsParams(parsed,this);
			//trace("Parsed model is : "+JSON.stringify(model));
			//trace('2:'+avmplus.getQualifiedClassName(model));
			
			
			/*trace("***********");
			trace(JSON.stringify(fillThisObject,null,' '));*/
		}
		
		public static function parse(text:String,catcherObject):void
		{
			parsParams(JSON.parse(text,reviver),catcherObject);
		}
		
		/*public function pars():*
		{
			//model.Password = '*****************************';
			//model.Password = '++++++++++++++++++++++++++++++++++++++++++++++++++++';
			trace('**2:'+avmplus.getQualifiedClassName(model));
			parsParams(parsed,this);
			//trace("Parsed model is : "+JSON.stringify(model));
			trace('3:'+avmplus.getQualifiedClassName(model));
			return model ;
		}*/
		
		private static function parsParams(fromObject:Object,toObject:*):void
		{
			//trace("ToOjbect class type is :"+avmplus.getQualifiedClassName(toObject));
			//trace("From object is : "+JSON.stringify(fromObject,null,' '));
			//trace("parsAgain : "+JSON.stringify(fromObject));
			//trace("parsTo : "+JSON.stringify(toObject));
			//trace("hassMessage : "+toObject.hasOwnProperty(i));
			var arr:Array ;
			var j:int,l:uint ;
			
			for(var i in fromObject)
			{
				var currentParam:Object = fromObject[i] ;
				if(toObject.hasOwnProperty(i))
				{
					//trace("parsd i is : "+i);
					//var parameterClassName:String = flash.utils.getQualifiedClassName(toObject[i]);
					//if(parameterClassName.indexOf("__AS3__.vec:")!=-1)
					if(toObject[i] is Vector.<*>)
					{
						//Clear vector if it is full
						//trace("(model as Vector.<*>).length : "+(fillThisObject as Vector.<*>).length);
						while((toObject[i] as Vector.<*>).length)
						{
							(toObject[i] as Vector.<*>).pop();
						}
						
						//trace("This is vector parameter");
						if(currentParam is Array)
						{
							var vecClassName:String = getQualifiedClassName(toObject[i]).split("__AS3__.vec::Vector.<").join('').split('>').join('');
							//trace("Vector element type is : "+vecClassName);
							var vecItemClass:Class = (getDefinitionByName(vecClassName) as Class)
							var vec:Vector.<*> = (toObject[i]) ;
							arr = currentParam as Array;
							l = arr.length ;
							//trace("pars "+l+" items");
							for(j = 0 ; j<l ; j++)
							{
								var newObject:Object = new vecItemClass();
								vec.push(newObject);
								//trace("element is : "+newObject+' > '+JSON.stringify(newObject));
								parsParams(arr[j],newObject);
							}
						}
						else if(currentParam!=null)
						{
							trace("The parameter "+i+" cannot pars on Vector");
						}
					}
					else if(toObject[i] is Array)
					{
						//trace("Tis is Array");
						if(currentParam is Array)
						{
							arr = currentParam as Array;
							l = arr.length ;
							for(j = 0 ; j<l ; j++)
							{
								toObject[i][j] = arr[j];
							}
						}
						else if(currentParam!=null)
						{
							trace("The parameter "+i+" cannot pars on Array");
						}
					}
					else if(toObject[i] is String 
						|| toObject[i] is Number 
						|| toObject[i] is Date 
						|| toObject[i] is Boolean 
						|| toObject[i] == null
					)
					{
						//trace("Put toObject : "+currentParam);
						//trace("befor update : "+avmplus.getQualifiedClassName(toObject[i]))
						toObject[i] = currentParam ;
						//trace("after update : "+avmplus.getQualifiedClassName(toObject[i])+' > '+toObject[i])
					}
					else
					{
						//trace("Current parameter is complex parameter");
						parsParams(currentParam,toObject[i]);
					}
					//__AS3__.vec::Vector.<*>
					/*var className:String = getQualifiedClassName(toObject[i]);
					if(className
						trace("getQualifiedClassName : "+className);*/
					/*	}*/
				}
				
				/*else
				{
					trace("There is no "+i+" defined");	
				}*/
			}
			//trace("ToOjbect isDone :"+avmplus.getQualifiedClassName(toObject));
		}
		
		private static function reviver(k,v):*
		{
			if(String(v).indexOf("\/Date(")!=-1)
			{
				var V:String = String(v) ;
				return new Date(Number(V.substring(6,V.length-2))) ;
			}
			return v ;
		}
	}
}