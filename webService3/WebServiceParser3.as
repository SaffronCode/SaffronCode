package webService3
{
	import flash.utils.ByteArray;
	
	/**this will generate dynamic classes from receved json*/
	public class WebServiceParser3
	{
		
		public static function pars(pureObject:*,classType:Class):Array
		{
			var arrayOfthisClass:Array = [] ;
			
			//SaffronLogger.log(classType+" parsed to this data : "+JSON.stringify(pureObject));
			
			for(var j = 0 ; pureObject!=null && j<pureObject.length ; j++)
			{
				var currentObject:Object = new classType();
				/*for(var k in pureObject[j])
				{
					if(currentObject.hasOwnProperty(k))
					{
						try
						{
							currentObject[k] = pureObject[j][k] ;
						}
						catch(e)
						{
							SaffronLogger.log(currentObject[k]+" is different from "+pureObject[j][k]);
						}
					}
				}*/
				currentObject = parsObjects(currentObject,pureObject[j]);
				arrayOfthisClass.push(currentObject as classType);
			}
			//SaffronLogger.log("♠♠♠ ♠♠♠parsed data is : "+JSON.stringify(arrayOfthisClass));
			return arrayOfthisClass ;
		}
		
		private static function parsObjects(dest:Object,source:Object):Object
		{
			if(source is Array)
			{
				dest = [];
				dest = source ;
			}
			else if(dest == null)
			{
				SaffronLogger.log("web parser: dest is null");
			}
			else
			{
				for(var k in source)
				{
					if(dest.hasOwnProperty(k))
					{
						try
						{
							dest[k] = source[k] ;
						}
						catch(e)
						{
							SaffronLogger.log("web parser: "+source[k]+" is different from "+dest[k]+' on '+k);
							parsObjects(dest[k],source[k]);
						}
					}
				}
			}
			return dest ;
		}
	}
}