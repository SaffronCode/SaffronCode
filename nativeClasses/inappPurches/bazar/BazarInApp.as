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
		
		private static function canselAllListeners():void
		{
			if(_iap==null)
			{
				return ;
			}
			_iap.removeEventListener(InAppPurchaseEvent.INIT_SUCCESS, onInitSuccess);
			_iap.removeEventListener(InAppPurchaseEvent.INIT_ERROR, onInitError);
			
			_iap.removeEventListener(InAppPurchaseEvent.PURCHASE_SUCCESS, onPurchaseSuccess);
			_iap.removeEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onPurchaseError);
			
			_iap.removeEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestoreConsumeSuccess);
			_iap.removeEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestoreConsumeError);
			
			_iap.removeEventListener(InAppPurchaseEvent.CONSUME_SUCCESS, onConsumeSuccess);
			_iap.removeEventListener(InAppPurchaseEvent.CONSUME_ERROR, onConsumeError);
		}
		
		public static function buy(key:String,productId:String,numberOfShop:uint,onBought:Function,onFaild:Function):void
		{
			trace("[[[[[[[[[CAFE BAZAR]]]]]]]]]]");
			if(_iap==null)
			{
				_iap = new InAppPurchase(); 
			}
			
			CurrentProdId = productId ;
			
			onDone = onBought ;
			onCanseled = onFaild ;
			
			canselAllListeners();
			if(!bazarInit)
			{
				trace("***connect to bazar...");
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
			trace( "InAppBilling supported2" );
			canselAllListeners();
			
			purchessItem();
		}
		
			/**Now purchess my item*/
			private static function purchessItem():void
			{
				trace("****Buy this item : "+CurrentProdId);
				canselAllListeners();
				_iap.addEventListener(InAppPurchaseEvent.PURCHASE_SUCCESS, onPurchaseSuccess);
				_iap.addEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onPurchaseError);
				_iap.purchase(CurrentProdId, InAppPurchaseDetails.TYPE_INAPP);
			}
			
				protected static function onPurchaseError(event:Event):void
				{
					canselAllListeners();
					trace("-----Purchase fails");
					onCanseled();
				}
				
				/**Puchase done*/
				protected static function onPurchaseSuccess(event:InAppPurchaseEvent):void
				{
					canselAllListeners();
					trace("-----Purchase done: ["+event.data+"] ... consume it");
					//onDone();
					consumeProduct(CurrentProdId,onDone,onCanseled);
				}
			
		protected static function onInitError(event:InAppPurchaseEvent):void
		{
			canselAllListeners();
			trace( "!!!!!!!!InAppBilling not supported" );
			trace(event.data); //trace error message
			onCanseled();
		}
		
//////////////////////////////////////////////////Consume or use the last bought product
		
		public static function consumeProduct(producID:String,onConsumed:Function,onFaildToConsume:Function):void
		{
			onDone = onConsumed ;
			onCanseled = onFaildToConsume;
			CurrentProdId = producID ;
			
			trace("*** Restore server to consume")
			canselAllListeners();
			_iap.addEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestoreConsumeSuccess);
			_iap.addEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestoreConsumeError);
			_iap.restore();
		}
		
			protected static function onRestoreConsumeError(event:InAppPurchaseEvent):void
			{
				canselAllListeners();
				trace( "restoreConsome Failed" );
				onCanseled();
			}
		
			protected static function onRestoreConsumeSuccess(event:InAppPurchaseEvent)
			{
				trace("**** request to consume product : "+CurrentProdId);
				canselAllListeners();
				
				_iap.addEventListener(InAppPurchaseEvent.CONSUME_SUCCESS, onConsumeSuccess);
				_iap.addEventListener(InAppPurchaseEvent.CONSUME_ERROR, onConsumeError);
				_iap.consume(CurrentProdId);
			}
			
				protected static function onConsumeSuccess(event:InAppPurchaseEvent):void
				{
					canselAllListeners();
					trace("Consume Success"); 
					onDone();
				}
				protected static function onConsumeError(event:InAppPurchaseEvent):void
				{
					canselAllListeners();
					trace("Consume Failed"); 
					onCanseled();
				}
		
	}
}