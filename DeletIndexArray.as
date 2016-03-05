package 
{
	public class DeletIndexArray
	{
		/**delete index of Array*/
		public function DeletIndexArray()
		{
		}
		public static function deletIndexArray_fun(arry_p:Array,id_p:int):Array
		{
			var _b:Array = arry_p.slice(0,id_p);
			var _c:Array = arry_p.slice(id_p+1,arry_p.length);
			arry_p = _b.concat(_c);
			return arry_p
		}
		public static function deletIndexVector_fun(vec_p:*,id_p:int):*
		{
			var _b:* = vec_p.slice(0,id_p);
			var _c:* = vec_p.slice(id_p+1,vec_p.length);
			vec_p = _b.concat(_c);
			return vec_p
		}

	}
}