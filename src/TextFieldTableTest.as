package {
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public final class TextFieldTableTest {
		
		public function TextFieldTableTest() {
			applyToAllTest();
			trace("Testを実行しました");
		}
		
		private function applyToAllTest():void{
			var table:TextFieldTable = new TextFieldTable(10, 10);
			
			function addTestText(t:TextField):void{ t.appendText("tst"); }
			table.applyToAll(addTestText);
			
			isEqual(table.TextFields[0][0].text , "tst");
			isEqual(table.TextFields[9][9].text , "tst");
		}
		
		private function isEqual(a:* , b:*):void{
			if (a != b) throw new Error("比較した値が異なります。")
		}
		
	}
}