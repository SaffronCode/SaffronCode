package save
{
	import flash.net.SharedObject;

	public class MultiSave
	{
		private static var saveId:Vector.<SharedId> = new Vector.<SharedId>()
		private var id:String;	
		public function MultiSave()
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
		public function get value():Object
		{
			if(getSharedObject(id).data.value==undefined)
			{
				return null
			}
			return shallowCopy(getSharedObject(id).data.value)
		}
		
		private	function shallowCopy(sourceObj:Object):Object 
		{
			var copyObj:Object = new Object();
			for (var i in sourceObj){
				copyObj[i] = sourceObj[i];
			}
			return copyObj;
		}	
		public function  set value(obj:Object):void
		{
			getSharedObject(id).data.value = shallowCopy(obj)
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
