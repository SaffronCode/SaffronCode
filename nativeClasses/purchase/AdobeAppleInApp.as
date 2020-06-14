package nativeClasses.purchase
{
	import com.adobe.ane.productStore.Product;
	import com.adobe.ane.productStore.ProductEvent;
	import com.adobe.ane.productStore.ProductStore;
	import com.adobe.ane.productStore.Transaction;
	import com.adobe.ane.productStore.TransactionEvent;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import com.Base64;

	public class AdobeAppleInApp
	{
		private static var ps:ProductStore ;
		
		private static var onFails:Function;
		private static var onDone:Function;
		
		public static function buy(productId:String,onTicketBought:Function,onFaildToBuy:Function):void
		{
			onDone = onTicketBought ;
			onFails = onFaildToBuy ;
			
			ps.addEventListener(ProductEvent.PRODUCT_DETAILS_FAIL,shoppingFails);
			ps.addEventListener(ProductEvent.PRODUCT_DETAILS_SUCCESS,continueShopping);
			var productsList:Vector.<String> = new Vector.<String>();
			productsList.push(productId);
			
			ps.requestProductsDetails(productsList);
		}
		
		/**Remove all listeners*/
		private static function removeAllListeners():void
		{
			ps.removeEventListener(ProductEvent.PRODUCT_DETAILS_FAIL,shoppingFails);
			ps.removeEventListener(ProductEvent.PRODUCT_DETAILS_SUCCESS,continueShopping);

			ps.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_SUCCESS,transactionSuccess);
			
			ps.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_CANCEL,transactionCanseled);
			ps.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_FAIL,transactionFails);
			ps.removeEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS ,finishTransactionSucceeded);
			
			
			ps.removeEventListener(TransactionEvent.RESTORE_TRANSACTION_FAIL,transactionFails);
			ps.removeEventListener(TransactionEvent.RESTORE_TRANSACTION_COMPLETE,transactionSuccess);
			
			//Restore transaction will not call
			ps.removeEventListener(TransactionEvent.RESTORE_TRANSACTION_SUCCESS,transactionSuccess);
		}
		
		/**Product detail fails*/
		protected static function shoppingFails(event:Event):void
		{
			SaffronLogger.log("♠Un able to load products detail");
			onFails();
		}
		
		protected static function continueShopping(event:ProductEvent):void
		{
			SaffronLogger.log("♠Continue shopping");
			removeAllListeners();
			if(event.products.length>0)
			{
				SaffronLogger.log("♠Product is : "+JSON.stringify(event.products[0]));
				
				var currentID:String = event.products[0].identifier ;
				
				ps.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_SUCCESS,transactionSuccess);
				
				ps.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_CANCEL,transactionCanseled);
				ps.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_FAIL,transactionFails);
				ps.addEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS ,finishTransactionSucceeded);
				
				
				ps.addEventListener(TransactionEvent.RESTORE_TRANSACTION_FAIL,transactionFails);
				ps.addEventListener(TransactionEvent.RESTORE_TRANSACTION_COMPLETE,transactionSuccess);
				
				//Restore transaction will not call
				ps.addEventListener(TransactionEvent.RESTORE_TRANSACTION_SUCCESS,finishTransactionSucceeded);
				SaffronLogger.log("♠Buy this : "+currentID);
				ps.makePurchaseTransaction(currentID);
			}
			else
			{
				SaffronLogger.log("♠The product code not found");
				onFails();
			}
		}
		
		protected static function transactionFails(event:Event):void
		{
			removeAllListeners();
			SaffronLogger.log("♠Transaction fails");
			onFails();
		}
		
		/**Transactin canseled*/
		protected static function transactionCanseled(event:Event):void
		{
			removeAllListeners();
			SaffronLogger.log("♠Transaction fails by user request");
			onFails()
		}
		
		protected static function transactionSuccess(e:TransactionEvent):void
		{
			removeAllListeners();
			var i:uint = 0;
			var t:Transaction;
			if(e.transactions.length==0)
			{
				SaffronLogger.log("♠ transaction fails ");
				onFails();
			}
			while(e.transactions && i < e.transactions.length)
			{
				t = e.transactions[i];
				printTransaction(t);
				i++;
				var Base:Base64=new Base64();
				var encodedReceipt:String = Base64.Encode(t.receipt);
				var req:URLRequest = new URLRequest("https://sandbox.itunes.apple.com/verifyReceipt");
				req.method = URLRequestMethod.POST;
				req.data = "{\"receipt-data\" : \""+ encodedReceipt+"\"}";
				var ldr:URLLoader = new URLLoader(req);
				ldr.load(req);
				SaffronLogger.log("Finish this transaction:"+t.identifier);
				ldr.addEventListener(Event.COMPLETE,function(e:Event):void{
					SaffronLogger.log("LOAD COMPLETE: " + ldr.data);
					ps.addEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS, finishTransactionSucceeded);
					ps.finishTransaction(t.identifier);
				});
				
			}
		}
		
		/**Print transaction*/
		private static function printTransaction(t:Transaction):void
		{
			return ;
			SaffronLogger.log("-------------------in Print Transaction----------------------");
			SaffronLogger.log("identifier :"+t.identifier);
			SaffronLogger.log("productIdentifier: "+ t.productIdentifier);
			SaffronLogger.log("productQuantity: "+t.productQuantity);
			SaffronLogger.log("date: "+t.date);
			SaffronLogger.log("receipt: "+t.receipt);
			SaffronLogger.log("error: "+t.error);
			SaffronLogger.log("originalTransaction: "+t.originalTransaction);
			if(t.originalTransaction)
				printTransaction(t.originalTransaction);
			SaffronLogger.log("---------end of print transaction----------------------------");
		}
		
		protected static function finishTransactionSucceeded(event:Event):void
		{
			removeAllListeners();
			//TODO
		}
	}
}