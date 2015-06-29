package webService.types
{
	/**this will generate dynamic classes from receved json*/
	public class WebServiceParser
	{
		public static function pars(jsonString:String,classType:Class):Array
		{
			jsonString = jsonCorrector(jsonString);
			var parsdObject:Object = {};
			try
			{
				parsdObject = JSON.parse(jsonString);
			}
			catch(e)
			{
				trace("I cannot pars this JSON : "+jsonString);
				return [];
			}
			
			var backdItems:Array = [] ;
			//{ "VUserGroupMember":[{ "PartyId":"3", "UserTypeBaseId":"11", "UserName":"s1", "Password":"System.Byte[]", "IsActive":"True", "GroupId":"", "GroupTitle":"", "RoleBaseId":"", "RoleBaseTitle":"", "HasImage":"0"}]}
			for each(var i in parsdObject)
			{
				var founded:Array = i ;
//[{ "PartyId":"3", "UserTypeBaseId":"11", "UserName":"s1", "Password":"System.Byte[]", "IsActive":"True", "GroupId":"", "GroupTitle":"", "RoleBaseId":"", "RoleBaseTitle":"", "HasImage":"0"}]
				for(var j = 0 ; j<founded.length ; j++)
				{
					/*{ "PartyId":"3"
					, "UserTypeBaseId":"11", "UserName":"s1", "Password":"System.Byte[]", "IsActive":"True", "GroupId":"", "GroupTitle":"", "RoleBaseId":"", "RoleBaseTitle":"", "HasImage":"0"}*/
					var currentObject:Object = new classType();
					for(var k in founded[j])
					{
						if(currentObject.hasOwnProperty(k))
						{
							currentObject[k] = founded[j][k] ;
						}
					}
					backdItems.push(currentObject);
				}
			}
			return backdItems ;
		}
		
		
		/**Correcting the json string*/
		private static function jsonCorrector(oldJson:String)
		{
			return oldJson.split('\n').join(' \\n').split('\r').join(' \\r').split('"').join('\"').split('\t').join('\\t') ;
		}
	}
}