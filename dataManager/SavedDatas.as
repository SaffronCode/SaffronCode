package dataManager
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class SavedDatas
	{
		private static var  sql:SQLConnection ,
							query:SQLStatement;
							
		private static var 	dbFolder:String = "DB",
							dbName:String = "saves",
							tableName:String = "SAVED_DATA",
							field_id:String = "ID",
							field_value:String = "VALUE";
		
		private static var unicCode:String = 'deviceUnicCode';
		
		private static var systemCode:String ;
		
		private static var temporaryObject:Object ;
		
		/**get the device unic code if there is or set a new one on it*/
		public static function setOrGetDeviceCode():String
		{
			return '18888485mteamapps.com156848514' ;
		}
		
		
		public static function setUp()
		{
			if(sql == null)
			{
				temporaryObject = {};
				var sqlFile:File = File.applicationStorageDirectory.resolvePath(dbFolder);
				if(!sqlFile.exists)
				{
					sqlFile.createDirectory() ;
				}
				sqlFile = sqlFile.resolvePath(dbName);
				
				var encrypt:ByteArray = new ByteArray();
				encrypt.writeUTFBytes(setOrGetDeviceCode().substring(0,16));
				
				sql = new SQLConnection();
				sql.open(sqlFile,"create",false,1024,encrypt);
				
				query = new SQLStatement();
				
				
				
				query.sqlConnection = sql ;
				try
				{
					query.text = "create table "+tableName+" ("+field_id+" VARCHAR(1) , "+field_value+" VARCHAR(1))";
					query.execute();
					SaffronLogger.log('table is creats');
				}
				catch(e)
				{
					SaffronLogger.log('table was created');
				}
			}
		}
		
		
		/**save stringifi value for this id on data base*/
		public static function save(id:String,data:String):void
		{
			setUp();
			//SaffronLogger.log("save this data : "+data);
			//hint : if data is nul , it will cause to skip this function ,at the bigining of the app job , all temporaryObject variables are null
			if(data!= null && temporaryObject[id] == data)
			{
				//SaffronLogger.log("temporaryObject[id] is : "+temporaryObject[id]);
				return ;
			}
			//SaffronLogger.log("save this data2 : "+temporaryObject[id]);
			temporaryObject[id] = data ;
			sql.begin();
			query.text = "delete from "+tableName+" where "+field_id+" == '"+id+"'" ;
			try
			{
				query.execute();
			}
			catch(e){}
			query.text = "insert into "+tableName+" ( "+field_id+" , "+field_value+" ) values( '"+id+"' , '"+data+"' )";
			try
			{
				query.execute();
				sql.commit();
				//SaffronLogger.log(data+" saved");
			}
			catch(e)
			{
				sql.rollback();
			}
		}
		
		
		/**load the value with this id if it saved befor<br>
		 * if no value founds , it will return null instead of some Stringifi data*/
		public static function load(id:String):*
		{
			setUp();
			var check:String = temporaryObject[id];
			if(check!=null)
			{
				return check;
			}
			
			//SaffronLogger.log("it have to send query to db to detect the data");
			
			query.text = "select "+field_value+" from "+tableName+" where "+field_id+" == '"+id+"'";
			try
			{
				query.execute();
				var result:SQLResult = query.getResult() ;
				if(result.data == null)
				{
					return null ;
				}
				else
				{
					//SaffronLogger.log('result on query is : '+(result.data[0][field_value]==null)+' > check string : '+(result.data[0][field_value]=='null'));
					var res:String = result.data[0][field_value] ;
					if(res == 'null')
					{
						res = null ;
					}
					return res ;
				}
			}
			catch(e){}
			return null ;
		}
		
		
		
	////////////////////////////////debug function for section id and mac id↓
		
	}
}