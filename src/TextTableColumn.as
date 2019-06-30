package {
	/**
	 * ...	テーブル内の列を表すクラスです。
	 */
	public class TextTableColumn {
		
		private var x:int = 0;
		public function get X():int { return x; }
		public function set X(posX:int):void {
			for each(var t:TextFieldForTable in textFields){
				t.x = posX;
				this.x = posX
			}
		}
		
		private var width:int = 0;
		public function get Width():int { return width; }
		public function set Width( w:int ):void {
			for each(var t:TextFieldForTable in textFields) { 
				t.width = w ;
				this.width = w;
			}
		}
		
		/** この列に属するセル群が数値専用のセルであるかどうかを表します。 */
		public var isNumericOnly:Boolean = false;
		
		private var textFields:Vector.<TextFieldForTable> = new Vector.<TextFieldForTable>;
		public function get TextFields():Vector.<TextFieldForTable> { return textFields; }
		
		public function TextTableColumn() {
			
		}
		
		/**	引数に入力したテキストフィールドを、この列クラスの管理下に加えます。
		 * @param	t	このメソッドを実行した時、引数のテキストフィールドのwidth,xフィールドが変化します。
		 */
		public function add(t:TextFieldForTable):void{
			t.x = x;
			t.width = width;
			textFields.push(t);
		}
		
		/**	この列に属する全てのテキストフィールドに対して、引数に入力したコールバックを実行します。
		 * @param	callBackFunction	関数の仕様は　callBackFunction(t:TextFieldForTable) です。
		 */
		public function applyToAll( callBackFunction:Function ):void{
			for each( var t:TextFieldForTable in textFields ){
				callBackFunction(t:TextFieldForTable);
			}
		}
	}
}