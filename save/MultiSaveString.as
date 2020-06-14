package save
{
	import flash.net.SharedObject;

	public class MultiSaveString
	{
		private static var saveId:Vector.<SharedId> = new Vector.<SharedId>()
		private var id:String;	
		public function MultiSaveString()
		{
		}
		public function setup(saveId_p:String):void
		{
			if(getSharedObject(saveId_p)==null)
			{
				var shard:SharedId = new SharedId()
				shard.SharedObj = SharedObject.getLocal(saveId_p)
				shard.sharedName = saveId_p
				saveId.push(shard)		
			}
			id = saveId_p
		}
		private function getSharedObject(id_p:String):SharedObject
		{
			for each(var index:SharedId in saveId)
			{
				if(index.sharedName == id_p) return index.SharedObj
			}
			return null
		}
		public function get value():String
		{
			if(getSharedObject(id).data.value==undefined)
			{
				return ''
			}
			return shallowCopy(getSharedObject(id).data.value)
		}
		
		private	function shallowCopy(sourceStr:String):String 
		{
			var _copyValue:String = sourceStr

			return _copyValue;
		}	
		public function  set value(Value_p:String):void
		{
			getSharedObject(id).data.value = shallowCopy(Value_p)
			flushingFun();
			
		}				
		public function Clear():void
		{
			getSharedObject(id).data.value = null;
			flushingFun();
		}
		
		
		public function Delete():void
		{
			delete getSharedObject(id).data.value;
		}
		
		
		private function flushingFun():void
		{
			var flushStatus:String = null;
			try
			{
				flushStatus = getSharedObject(id).flush();
			}
			catch (error:Error)
			{
				SaffronLogger.log("Error...Could not write SharedObject to disk");
			}
		}

	}
}
