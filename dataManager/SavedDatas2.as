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
	
	/**none encripted sql db*/
	public class SavedDatas2
	{
		private static var  sql:SQLConnection ,
							asyncSql:SQLConnection,
							query:SQLStatement,
							asyncQuery:SQLStatement;
							
		private static var asyncSQLisOpened:Boolean = false ;
							
							
		private static var asyncQue:Vector.<SavedDataQueeItem> = new Vector.<SavedDataQueeItem>(),
							asyncSaved:Vector.<SavedDataQueeItem> = new Vector.<SavedDataQueeItem>();
		
		private static const tableBaseName:String = "SAVED_DATA";
		
		private static var 	dbFolder:String = "DB",
			dbName:String = "saves2",
			dbNameNew:String = "saves3",
			dbUpdatedName:String = "updatedSaves",
			dbUpdatedNameNew:String = "updatedSaves2",
			tableName:String = tableBaseName,
			field_id:String = "ID",
			field_value:String = "VALUE",
			field_date:String = "DATE";
		
		private static var key:ByteArray ;
		
		//private static var systemCode:String ;
		
		/**it is object of objects with data and time parameters on each of them<br>
		 * {{data:-,time:-},{data:-,time:-}}*/
		//private static var temporaryObject:Object ;
		
		/**This is a date that the last cash was saved*/
		public static var savedDate:Number ;
		
		
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
		
		/**Change the table name for this special user*/
		public static function setTableName(tableNameTitle:String=''):void
		{
			tableName = tableBaseName+tableNameTitle;
			SaffronLogger.log("new table name is : "+tableName);
			setUp();
		}
		
		
		
		
		
		public static function setUp(checkTable:Boolean = false):void
		{
			var needToUpdate:Boolean = false ;
			if(sql == null)
			{
				key = new ByteArray();
				const code:String = DevicePrefrence.DeviceUniqueId() ;
				for(var i:int = 0 ; key.length<16 ; i++)
				{
					key.writeUTFBytes(code.charAt(i%code.length));
				}
				
				needToUpdate = true ;
				checkTable = true ;
				//temporaryObject = {};
				var sqlFile:File = File.applicationStorageDirectory.resolvePath(dbFolder);
				var updatedFile:File = sqlFile.clone();
				if(!sqlFile.exists)
				{
					sqlFile.createDirectory() ;
				}
				var sqlToRemoveFile:File = sqlFile.resolvePath(dbName);
				
				try
				{
					if(sqlToRemoveFile.exists)
						sqlToRemoveFile.deleteFile();
				}catch(e){};
				
				sqlFile = sqlFile.resolvePath(dbNameNew);
				sqlToRemoveFile = updatedFile.resolvePath(dbUpdatedName);
				try
				{
					if(sqlToRemoveFile.exists)
						sqlToRemoveFile.deleteFile();
				}catch(e){};
				
				updatedFile = updatedFile.resolvePath(dbUpdatedNameNew);
				if(updatedFile.exists)
				{
					try
					{
						updatedFile.copyTo(sqlFile,true);
					}
					catch(e){SaffronLogger.log("SavedData2 SetUp error : "+e)}
				}
				
				/*var encrypt:ByteArray = new ByteArray();
				encrypt.writeUTFBytes(setOrGetDeviceCode().substring(0,16));*/
				
				sql = new SQLConnection();
				try
				{
					SaffronLogger.log("Is DB exists? "+sqlFile.exists);
					sql.open(sqlFile,SQLMode.CREATE,false,1024,key);
				}
				catch(e:Error)
				{
					SaffronLogger.log("Error happend : "+e.message);
					sql = null ;
					var lostDB:File = updatedFile.parent.resolvePath('lostDB'+new Date().time);
					//SaffronLogger.log("updatedFile : "+updatedFile.nativePath);
					if(updatedFile.exists)
					{
						//SaffronLogger.log("lostDB : "+lostDB.nativePath);
						updatedFile.moveTo(lostDB);
					}
					if(sqlFile.exists)
						sqlFile.deleteFile();
					setUp(checkTable);
					return;
				}

				
				asyncSql = new SQLConnection();
				asyncSql.addEventListener(SQLEvent.OPEN,asincSQLisReady);
				asyncSql.addEventListener(SQLErrorEvent.ERROR,rollBaskAsyncSQL);
				
				query = new SQLStatement();
				query.sqlConnection = sql ;
				
				asyncQuery = new SQLStatement();
				asyncQuery.sqlConnection = asyncSql ;
				
			}
			if(checkTable)
			{
				try
				{
					query.text = "create table "+tableName+" ("+field_id+" VARCHAR(1) , "+field_value+" BLOB , "+field_date+" INT) ";
					query.execute();
					SaffronLogger.log('table is creats');
				}
				catch(e)
				{
					SaffronLogger.log('table was created');
				}
				
				try
				{
					query.text = "create index if not EXISTS "+tableName+"_indexes on "+tableName+" ("+field_id+");" ;
					query.execute() ;
					SaffronLogger.log('index is creates') ;
				}
				catch(e)
				{
					SaffronLogger.log('Create index problem') ;
				}
			}
			
			if(needToUpdate)
			{
				SaffronLogger.log("sqlFile : "+sqlFile.nativePath);
				SaffronLogger.log("updatedFile : "+updatedFile.nativePath);
				if(!updatedFile.exists)
				{
					sqlFile.copyTo(updatedFile);
				}
				asyncSql.openAsync(updatedFile,SQLMode.CREATE,null,false,1024,key);
			}
		}
		
		/**SQL is opened*/
		protected static function asincSQLisReady(event:SQLEvent):void
		{
			SaffronLogger.log("****SQL is open****");
			asyncSQLisOpened = true ;
			asyncSql.removeEventListener(SQLEvent.OPEN,asincSQLisReady);
			if(!asyncQuery.executing)
			{
				saveTheQuee();
			}
		}
		
		protected static function rollBaskAsyncSQL(event:SQLErrorEvent):void
		{
			asyncSql.rollback();
		}		
		
		/**save stringifi value for this id on data base*/
		public static function save(id:String,data:*):void
		{
			setUp();
			SaffronLogger.log("Save !!");
			var dateNum:Number = new Date().time;
			asyncQue.push(new SavedDataQueeItem(id,data,dateNum));
			SaffronLogger.log("asyncSQLisOpened : "+asyncSQLisOpened);
			SaffronLogger.log("asyncQuery.executing : "+asyncQuery.executing);
			if(asyncQuery.executing || !asyncSQLisOpened)
			{
				SaffronLogger.log("**Async db is bussy right now ...");
				return ;
			}
			
			saveTheQuee();
			
		}
		
		private static function saveTheQuee():void
		{
			if(asyncQue.length==0)
			{
				return ;
			}
			var id:String = asyncQue[0].id ;
			var data:* = asyncQue[0].data ;

			
			asyncQuery.clearParameters();
			asyncQuery.text = "delete from "+tableName+" where "+field_id+" == @"+field_id ;
			asyncQuery.parameters['@'+field_id] = id ;
			SaffronLogger.log("*************** asyncQuery.text : "+asyncQuery.text);
			
			
			asyncQuery.addEventListener(SQLEvent.RESULT,continueSaving);
			asyncQuery.execute();
		}
		
			private static function continueSaving(e:*=null):void
			{
				var id:String = asyncQue[0].id ;
				var data:* = asyncQue[0].data ;
				var date:Number = asyncQue[0].date ;
				SaffronLogger.log("************Query executed");
				asyncQuery.removeEventListener(SQLEvent.RESULT,continueSaving);
				//( "+field_id+" , "+field_value+" , "+field_date+" )
				asyncQuery.text = "insert into "+tableName+"  values( @"+field_id+" , @"+field_value+" , "+date+" )";
				asyncQuery.parameters["@"+field_id] =  id ;
				asyncQuery.parameters["@"+field_value] =  data ;
				
				//SaffronLogger.log("query.text : "+query.text);
				
				asyncQuery.addEventListener(SQLEvent.RESULT,savingCompleted);
				asyncQuery.execute();
				//asyncSql.commit();
			}
			
				protected static function savingCompleted(event:SQLEvent):void
				{
					asyncQuery.removeEventListener(SQLEvent.RESULT,savingCompleted);
					asyncSaved.push(asyncQue.shift());
					saveTheQuee();
				}
		
		/**load the value if the value is new on data base*/
		public static function loadIfNewer(id:*,lastDate:Date=null):*
		{
			return load(id,lastDate);
		}
		
		
		/**load the value with this id if it saved befor<br>
		 * if no value founds , it will return null instead of some Stringifi data*/
		public static function load(id:String,lastAcceptableDate:Date=null):*
		{
			//TimeTracer.tr("get "+id);
			setUp();
			
			var l:uint = asyncQue.length ;
			var l2:uint = asyncSaved.length ;
			for(var i:* = l-1 ; i>=0 ; i--)
			{
				if(asyncQue[i].id == id)
				{
					//TimeTracer.tr("founded "+id);
					savedDate = asyncQue[i].date ;
					return asyncQue[i].data ;
				}
			}
			for(i = l2-1 ; i>=0 ; i--)
			{
				if(asyncSaved[i].id == id)
				{
					if(lastAcceptableDate===null || asyncSaved[i].date>lastAcceptableDate.time)
					{
						//TimeTracer.tr("founded "+id);
						savedDate = asyncSaved[i].date ;
						return asyncSaved[i].data ;
					}
					else
					{
						return null ;
					}
				}
			}
			
			var dateControllQuery:String = '' ;
			if(lastAcceptableDate != null)
			{
				var lastDate:Number = lastAcceptableDate.time ;
				SaffronLogger.log("requested date : "+lastDate);
				dateControllQuery = ' and '+field_date+" >= "+lastDate ;
			}
			//var check:Object = temporaryObject[id];
			/*if(check!=null)
			{
			return check.data;
			}*/
			
			//SaffronLogger.log("it have to send query to db to detect the data");
			query.clearParameters();
			query.text = "select "+field_value+','+field_date+" from "+tableName+" where "+field_id+" == @"+field_id+dateControllQuery;
			query.parameters["@"+field_id] = id ;
			
			//SaffronLogger.log("query.text  : "+query.text);
			try
			{
				query.execute();
				var result:SQLResult = query.getResult() ;
				if(result.data == null)
				{
					//SaffronLogger.log("didnt found");
					return null ;
				}
				else
				{
					//SaffronLogger.log("data founds : "+result.data[0]);
					//SaffronLogger.log('result on query is : '+(result.data[0][field_value]==null)+' > check string : '+(result.data[0][field_value]=='null'));
					var res:* = result.data[0][field_value] ;
					savedDate = result.data[0][field_date] ;
					//TimeTracer.tr("founded on db "+id);
					return res ;
				}
			}
			catch(e)
			{
				SaffronLogger.log("DB error : "+e);
			}
			return null ;
		}
		
		
		
		////////////////////////////////debug function for section id and mac id↓
		
	}
}

