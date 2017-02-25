package nativeClasses.inappPurches.bazar
{
	import com.pozirk.payment.android.InAppPurchase;
	import com.pozirk.payment.android.InAppPurchaseDetails;
	import com.pozirk.payment.android.InAppPurchaseEvent;
	
	import flash.events.Event;

	public class BazarInApp
	{
		private static var _iap:InAppPurchase;
		
		private static var onDone:Function,
							onCanseled:Function;
							
		private static var bazarInit:Boolean = false ;
		
		private static var CurrentProdId:String ;
		
		public static function buy(key:String,productId:String,numberOfShop:uint,onBought:Function,onFaild:Function):void
		{
			if(_iap==null)
			{
				_iap = new InAppPurchase(); 
			}
			
			CurrentProdId = productId ;
			
			onDone = onBought ;
			onCanseled = onFaild ;

			if(!bazarInit)
			{
				_iap.addEventListener(InAppPurchaseEvent.INIT_SUCCESS, onInitSuccess);
				_iap.addEventListener(InAppPurchaseEvent.INIT_ERROR, onInitError);
				_iap.init(key);
			}
			else
			{
				trace( "InAppBilling supported" );
				purchessItem();
			}
		}
		
		protected static  function onInitSuccess(event:InAppPurchaseEvent):void
		{
			bazarInit = true ;
			trace( "InAppBilling supported" );
			_iap.removeEventListener(InAppPurchaseEvent.INIT_SUCCESS, onInitSuccess);
			_iap.removeEventListener(InAppPurchaseEvent.INIT_ERROR, onInitError);
			
			purchessItem();
		}
		
			/**Now purchess my item*/
			private static function purchessItem():void
			{
				_iap.addEventListener(InAppPurchaseEvent.PURCHASE_SUCCESS, onPurchaseSuccess);
				_iap.addEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onPurchaseError);
				_iap.purchase(CurrentProdId, InAppPurchaseDetails.TYPE_INAPP);
				
				
			}
			
				protected static function onPurchaseError(event:Event):void
				{
					trace("-----Purchase fails");
					onCanseled();
				}
				
				/**Puchase done*/
				protected static function onPurchaseSuccess(event:Event):void
				{
					trace("-----Purchase done");
					onDone();
				}
			
		protected static function onInitError(event:InAppPurchaseEvent):void
		{
			trace( "!!!!!!!!InAppBilling not supported" );
			trace(event.data); //trace error message
			onCanseled();
		}
		
	}
}