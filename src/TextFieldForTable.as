package {
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author 
	 */
	public class TextFieldForTable extends TextField {
		
		private var indexOfShowingValue:int = -1;
		public function get IndexOfShowingValue():int{ return indexOfShowingValue };
		public function set IndexOfShowingValue(val:int):void{
			if(val < 0) throw ArgumentError("このプロパティの引数は正の数でなければなりません。")
		}
		
		public function TextFieldForTable() {
			super();
		}
		
	}

}