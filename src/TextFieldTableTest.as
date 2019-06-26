package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author 
	 */
	public final class TextFieldTableTest extends Sprite {
		
		private var assertionCount:int = 0;
		
		public function TextFieldTableTest() {
			applyToAllTest();
			dataSourceTest();
			scrollUpAndDownTest();
			
			//テーブルから文字列の書き込みイベントがディスパッチされるかテスト
			textFieldTableEventDispatchTest();
			
			trace(assertionCount + " 回の比較テストが実行されました");
		}
		
		private function textFieldTableEventDispatchTest():void {
			var table:TextFieldTable = new TextFieldTable(10, 10);
			var sprites:Array = new Array();
			for (var i:int = 0; i < 40; i++){
				var sp:Sprite = new Sprite();
				sp.x = i;
				sprites.push(sp);
			}
			
			var j:int = 0;
			var countDownCounter:int = 0;
			for (var k:int = 0; k < 10; k++){ countDownCounter += k; }
			
			function textWriting(e:Event):void { 
				var textWritingEvent:TextWriting = TextWriting(e);
				isEqual(j , textWritingEvent.target.text);
				countDownCounter -= textWritingEvent.originalValue;
				j++;
			}
			
			
			table.addEventListener(TextWriting.TEXT_WRITING, textWriting);
			table.ColumnPropertyNames = new < String > ["x"];
			
			//データソースをセットすると、文字列が表に書き込まれ、イベントが発行される。
			table.DataSource = sprites;
			
			isEqual(countDownCounter , 0);
		}
		
		private function scrollUpAndDownTest():void {
			
			var table:TextFieldTable = new TextFieldTable(10, 10);
			this.addChild(table);
			var sprites:Array = new Array();
			for (var i:int = 0; i < 40; i++){
				var sp:Sprite = new Sprite();
				sp.x = i;
				sp.y = i * 2;
				sp.z = i * 3;
				sp.visible = false;
				sprites.push(sp)
			}
			
			table.ColumnPropertyNames = new < String > ["x", "y", "z" , "visible"];
			table.DataSource = sprites;
			
			//可視領域の最初のセルと最後のセルの値を比較。
			var currentVisibleRange:Rectangle = table.VisibleRange;
			isEqual(sprites[ currentVisibleRange.y ].x , 0);
			isEqual(sprites[ currentVisibleRange.y ].y , 0);
			
			isEqual(sprites[ currentVisibleRange.y + currentVisibleRange.height -1].x , 9);
			isEqual(sprites[ currentVisibleRange.y + currentVisibleRange.height -1].y , 18);
			
			//スクロールを実行する。可視領域が４段下へ。
			table.scrollDown(4);
			
			currentVisibleRange = table.VisibleRange;
			isEqual(sprites[ currentVisibleRange.y ].x , 4);
			isEqual(sprites[ currentVisibleRange.y ].y , 8);
			
			isEqual(sprites[ currentVisibleRange.y + currentVisibleRange.height -1].x , 13);
			isEqual(sprites[ currentVisibleRange.y + currentVisibleRange.height -1].y , 26);
			
			//今度は可視領域を２段上へ移動
			table.scrollUp(2);
			
			currentVisibleRange = table.VisibleRange;
			isEqual(sprites[ currentVisibleRange.y ].x , 2);
			isEqual(sprites[ currentVisibleRange.y ].y , 4);
			
			isEqual(sprites[ currentVisibleRange.y + currentVisibleRange.height -1].x , 11);
			isEqual(sprites[ currentVisibleRange.y + currentVisibleRange.height -1].y , 22);
			
			//過剰に大きな値
			table.scrollDown(100);
			
			//30段目から39段目が表示されている。
			currentVisibleRange = table.VisibleRange;
			isEqual(sprites[ currentVisibleRange.y ].x , 30);
			isEqual(sprites[ currentVisibleRange.y + currentVisibleRange.height -1 ].x , 39);
			
			//過剰に小さな値
			table.scrollUp(200);
			
			//0段目から9段目が表示される。
			currentVisibleRange = table.VisibleRange;
			isEqual(sprites[ currentVisibleRange.y ].x , 0);
			isEqual(sprites[ currentVisibleRange.y + currentVisibleRange.height -1 ].x , 9);
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
			assertionCount++;
		}
		
	}
}