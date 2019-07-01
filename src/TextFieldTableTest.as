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
			textFieldColumnTest();
			
			//テーブルから文字列の書き込みイベントがディスパッチされるかテスト
			textFieldTableEventDispatchTest();
			
			trace(assertionCount + " 回の比較テストが実行されました");
		}
		
		private function textFieldColumnTest():void {
			var table:TextFieldTable = new TextFieldTable(10, 10);
			var sprites:Array = new Array();
			for (var i:int = 0; i < 40; i++){
				var sp:Sprite = new Sprite();
				sp.x = i;
				sp.y = i * 2;
				sp.z = i * 3;
				sprites.push(sp);
			}
			
			addChild(table);
			table.ColumnPropertyNames = new < String > ["x", "y", "z"];
			table.DataSource = sprites;
			
			table.columns[1].Width = 200;
			isEqual(table.columns[0].Width ,40);// 列のデフォルト幅は40;
			isEqual(table.columns[1].X , 40); //　２列目のXは一列目の幅と同じになる。
			isEqual(table.columns[2].X , 240);// ２列目の幅が変更されて200pxになっているので、期待値は w200 + x40 = x240
			isEqual(table.columns[3].X , 280);// 以降全列の以上の列の幅変更が適用されているかテスト
			isEqual(table.columns[4].X , 320);
			isEqual(table.columns[5].X , 360);
			isEqual(table.columns[6].X , 400);
			isEqual(table.columns[7].X , 440);
			isEqual(table.columns[8].X , 480);
			isEqual(table.columns[9].X , 520);
			
			isEqual(table.columns[1].headerTextField.x , 40);	//	ヘッダーセルの位置情報も全く同じになっているはず。
			isEqual(table.columns[2].headerTextField.x , 240);
			isEqual(table.columns[3].headerTextField.x , 280);
			isEqual(table.columns[4].headerTextField.x , 320);
			isEqual(table.columns[5].headerTextField.x , 360);
			isEqual(table.columns[6].headerTextField.x , 400);
			isEqual(table.columns[7].headerTextField.x , 440);
			isEqual(table.columns[8].headerTextField.x , 480);
			isEqual(table.columns[9].headerTextField.x , 520);
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
				var textWritingEvent:TextTableEvent = TextTableEvent(e);
				isEqual(j , textWritingEvent.target.text);
				countDownCounter -= textWritingEvent.originalValue;
				j++;
			}
			
			
			table.addEventListener(TextTableEvent.CELL_TEXT_WRITING, textWriting);
			table.ColumnPropertyNames = new < String > ["x"];
			
			//データソースをセットすると、文字列が表に書き込まれ、イベントが発行される。
			table.DataSource = sprites;
			
			isEqual(countDownCounter , 0);
		}
		
		private function scrollUpAndDownTest():void {
			
			var table:TextFieldTable = new TextFieldTable(10, 10);
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