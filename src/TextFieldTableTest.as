package {
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public final class TextFieldTableTest extends Sprite {
		
		public function TextFieldTableTest() {
			applyToAllTest();
			dataSourceTest();
			trace("Testを実行しました");
		}
		
		
		private function dataSourceTest():void {
			var table:TextFieldTable = new TextFieldTable(10, 10);
			this.addChild(table);
			var vec:Array = new Array();
			for (var i:int = 0; i < 40; i++){
				var sp:Sprite = new Sprite();
				sp.x = i;
				sp.y = i * 2;
				sp.z = i * 3;
				sp.visible = false;
				vec.push(sp)
			}
			
			table.ColumnPropertyNames = new <String> ["x", "y", "z" ,"visible"];
			table.DataSource = vec;
			
			//正常にセッティングできていればこの値がデータソース（表）に入っている。
			isEqual(table.getValue(0, 0), 0);
			isEqual(table.getValue(1, 3), "false");
			removeChild(table);
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