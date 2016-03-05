package tableManager.data
{

	public class Type
	{
		public var ParagraphType:Paragraph = null,
					PictrueType:Pictrue = null,
					ButtonType:Button= null,
					InputTextType:InputText=null,
					RadioButtonTaype:RadioButtons=null,
					NumberRagneType:NumberRangeTable=null,
					ChekBoxType:ChekBox = null;

		public function Type()
		{
			
		}
		public function getType():*
		{
			if(ButtonType!=null)
			{	
				return ButtonType
			}
			if(InputTextType!=null)
			{
				return InputTextType
			}
			if(ParagraphType!=null)
			{
				return ParagraphType
			}
			if(PictrueType!=null)
			{
				return PictrueType
			}	
			if(RadioButtonTaype!=null)
			{
				return RadioButtonTaype
			}	
			if(NumberRagneType!=null)
			{
				return NumberRagneType
			}	
			if(ChekBoxType!=null)
			{
				return ChekBoxType
			}	
			return null
		}
	}
}