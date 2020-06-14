package contents.fileSystem
{
	import flash.data.EncryptedLocalStore;
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	/**none encripted sql db <br>
	 * This data base generated for images url saver , this class have to be global*/
	public class SavedDatas
	{
		private static var  sql:SQLConnection ,
							query:SQLStatement;
		
		private static var 	dbFolder:String = "DB",
							dbName:String = "saves3",
							tableName:String = "SAVED_DATA",
							field_id:String = "ID",
							field_value:String = "VALUE",
							field_date:String = "DATE";
		
		/**return true if the offline date number is not old*/
		private static function maxOfflineDate(offlineDate:Number,lastAcceptableDate:Date):Boolean
		{
			if(lastAcceptableDate == null)
			{
				//set the last acceptable date
				lastAcceptableDate = new Date();
				lastAcceptableDate.hours--;
			}
			if(offlineDate < lastAcceptableDate.time)
			{
				return false ;
			}
			else
			{
				return true ;
			}
		}
		
		
		//private static var systemCode:String ;
		
		/**it is object of objects with data and time parameters on each of them<br>
		 * {id:{data:-,time:-},id:{data:-,time:-}}*/
		private static var temporaryObject:Object ;
		
		
		
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
				
				/*var encrypt:ByteArray = new ByteArray();
				encrypt.writeUTFBytes(setOrGetDeviceCode().substring(0,16));*/
				
				sql = new SQLConnection();
				sql.open(sqlFile,SQLMode.CREATE);
				
				query = new SQLStatement();
				
				
				
				query.sqlConnection = sql ;
				try
				{
					query.text = "create table "+tableName+" ("+field_id+" VARCHAR(1) , "+field_value+" VARCHAR(1) , "+field_date+" INT) ";
					query.execute();
					SaffronLogger.log('table is creats');
				}
				catch(e)
				{
					SaffronLogger.log('table was created');
				}
				
				loadTemp();
			}
		}
		
		
		/**save stringifi value for this id on data base*/
		public static function save(id:String,data:String):void
		{
			setUp();
			//SaffronLogger.log("save this data : "+data);
			//hint : if data is nul , it will cause to skip this function ,at the bigining of the app job , all temporaryObject variables are null
			var dateNum:Number = new Date().time;
			if(data!= null && temporaryObject[id]!=undefined && temporaryObject[id].data == data)
			{
				sql.begin();
				query.text = "update "+tableName+" set "+field_date+" = "+dateNum+" where "+field_id+" == "+id;
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
				//SaffronLogger.log("temporaryObject[id] is : "+temporaryObject[id]);
				return ;
			}
			//SaffronLogger.log("save this data2 : "+temporaryObject[id]);
			temporaryObject[id] = {} ;
			temporaryObject[id].data = data ;
			temporaryObject[id].time = dateNum ;
			sql.begin();
			query.text = "delete from "+tableName+" where "+field_id+" == '"+id+"'" ;
			try
			{
				query.execute();
			}
			catch(e){}
			query.text = "insert into "+tableName+" ( "+field_id+" , "+field_value+" , "+field_date+" ) values( '"+id+"' , '"+data+"' , "+dateNum+" )";
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
		
		/**load the value if the value is new on data base*/
		public static function loadIfNewer(id,lastDate:Date=null,dontNeedToLoadSQLAgain:Boolean = true ):*
		{
			setUp();
			var check:Object = temporaryObject[id];
			if(check!=null && maxOfflineDate(check.time,lastDate))
			{
				return check.data;
			}
			
			if(dontNeedToLoadSQLAgain)
			{
				return null ;
			}
			
			//SaffronLogger.log("it have to send query to db to detect the data");
			
			query.text = "select "+field_value+" , "+field_date+" from "+tableName+" where "+field_id+" == '"+id+"'";
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
					
					if(maxOfflineDate(result.data[0][field_date],lastDate))
					{
						return res ;
					}
					else
					{
						SaffronLogger.log('saved Data is too old');
						return null ;
					}
				}
			}
			catch(e){}
			return null ;
		}
		
		
		/**load the value with this id if it saved befor<br>
		 * if no value founds , it will return null instead of some Stringifi data*/
		public static function load(id:String,dontNeedToLoadSQLAgain:Boolean = true ):*
		{
			setUp();
			var check:Object = temporaryObject[id];
			if(check!=null)
			{
				return check.data;
			}
			
			if(dontNeedToLoadSQLAgain)
			{
				return null ;
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
		
		/**load all table on object to get ready for fast acts*/
		private static function loadTemp()
		{
			query.text = "select * from "+tableName;
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
					for(var i = 0 ; i<result.data.length ; i++)
					{
						//SaffronLogger.log('load data for '+JSON.stringify(result.data[i]));
						temporaryObject[result.data[i][field_id]] = {} ;
						temporaryObject[result.data[i][field_id]].data = result.data[i][field_value] ;
						temporaryObject[result.data[i][field_id]].time = result.data[i][field_date] ;
					}
				}
			}
			catch(e)
			{
			}
		}
		
		
		/**Detecting all datas older that entered date*/
		public static function getDatasOlderThan(currentDate:Date):Array
		{
			setUp();
			query.text = "select "+field_value+" FROM "+tableName+" where "+field_date+" < "+currentDate.time;
			var foundedArray:Array = [] ;
			try
			{
				query.execute();
				var result:Array = query.getResult().data;
				for(var i = 0 ; result!=null && i<(result as Array).length ; i++)
				{
					foundedArray.push(result[i][field_value]);
				}
			}catch(e){};
			return foundedArray;
		}
		
		
		/**Deleting all datas older that entered date*/
		public static function removeDatasOlderThan(currentDate:Date):void
		{
			setUp();
			query.text = "delete FROM "+tableName+" where "+field_date+" < "+currentDate.time;
			try
			{
				query.execute();
				temporaryObject = new Object();
			}catch(e){};
		}
		
		
		////////////////////////////////debug function for section id and mac id↓
		
	}
}

