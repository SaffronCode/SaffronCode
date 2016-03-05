package save
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	public class Save
	{
		private static var nameSharedObj:SharedObject;
		public function Save()
		{
		}
		public function getNameShardObj_fun(nameObj_p:String):void
		{
			nameSharedObj = SharedObject.getLocal(nameObj_p);
		}
		public function get value():Object
		{
			if(nameSharedObj.data.value==undefined)
			{
				return null
			}
			return shallowCopy(nameSharedObj.data.value)
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
			nameSharedObj.data.value = shallowCopy(obj)
			flushingFun();

		}				
		public function Clear():void
		{
			nameSharedObj.data.value = null;
			flushingFun();
		}
		
			
		public function Delete():void
		{
			delete nameSharedObj.data.value;
		}
			
			
		private function flushingFun():void
		{
			var flushStatus:String = null;
			try
			{
				flushStatus = nameSharedObj.flush();
			}
			catch (error:Error)
			{
				trace("Error...Could not write SharedObject to disk");
			}
		}
	}
}