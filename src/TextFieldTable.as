package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author 
	 */
	public class TextFieldTable extends Sprite{
		
		private var textFields:Vector.<Vector.<TextFieldForTable>> = new Vector.<Vector.<TextFieldForTable>>;
		public function get TextFields():Vector.<Vector.<TextFieldForTable>> { return textFields };
		
		private var dataSource:Array
		public function set DataSource(dataSource:Array):void{ 
			this.dataSource = dataSource;
			writeVisibleRange();
		};
		
		private var columnPropertyNames:Vector.<String> = new Vector.<String>();
		
		/**
		 * このプロパティにテキストのベクターをセットすると、文字列が示すプロパティをデータソース内のオブジェクトから参照し、値がカラムに書き込まれます。
		 * また、ヘッダー行にもベクター内の文字列がセットされ、表示されます。
		 * 使用例: このプロパティに [ "x","y","visible" ]　をセット
		 * 仮にデータソース内のオブジェクトが Sprite ならば、描画される表には
		 * 
		 * Sprite.xの値  Sprite.yの値  Sprite.visibleの値
		 * 
		 * というように値が入力されて表示される。
		 */
		public function set ColumnPropertyNames(names:Vector.<String>):void{ 
			for (var i:int = 0; i < names.length; i++){
				columns[i].headerTextField.text = names[i];
			}
			columnPropertyNames = names;
			
			if (dataSource) writeVisibleRange();
		}
		
		public var columns:Vector.<TextTableColumn> = new Vector.<TextTableColumn>;
		
		private var visibleRange:Rectangle;
		public function get VisibleRange():Rectangle { return visibleRange };
		
		private var editingString:String = "";
		private var focusingTextField:TextFieldForTable;
		
		public function getValue(rowIndex:int , columnIndex:int):String{
			return String(dataSource[rowIndex][columnPropertyNames[columnIndex]]);
		}
		
		/**
		 * 
		 * @param	initialRowCount		初期状態での表の行数を指定します。
		 * @param	initialColumnCount	初期状態での列の行数を指定します。
		 * @param	defaultCellSample	初期状態で生成される表を構成するマス（テキストフィールド）のサンプルを指定します。
		 * 			初期状態の全てのマスが、ここで指定されたテキストフィールドの情報をコピーします。
		 */
		public function TextFieldTable(initialRowCount:int , initialColumnCount:int , defaultCellSample:TextField = null) {
			
			//　ループで列ベクターに列オブジェクトを挿入しつつ、それぞれに次の列への参照を渡していく。
			for (var i:int = 0; i < initialColumnCount; i++){
				var c:TextTableColumn = new TextTableColumn;
				if(i != 0) columns[i -1].ReferenceToNextColumn = c;
				columns.push(c);
			}
			
			for (i = 0; i < initialRowCount; i++){
				var newRow:Vector.<TextFieldForTable> = new Vector.<TextFieldForTable>;
				for (var j:int = 0; j < initialColumnCount; j++){
					var tFld:TextFieldForTable = new TextFieldForTable();
					if (defaultCellSample != null){
						tFld.copyProperties(defaultCellSample);
					}
					else{
						tFld.multiline = false;
						tFld.border = true;
						tFld.width = 40;
						tFld.height = 30;
					}
					
					tFld.x = j * tFld.width;
					tFld.y = i * tFld.height;
					tFld.type = TextFieldType.INPUT;
					tFld.addEventListener(FocusEvent.FOCUS_OUT , focusOuted);
					tFld.addEventListener(FocusEvent.FOCUS_IN , focusEntered);
					addChild(tFld);
					newRow.push(tFld);
					columns[j].Width = tFld.width;
					columns[j].X = tFld.x;
					columns[j].add(tFld);
				}
				textFields.push(newRow);
			}
			visibleRange = new Rectangle(0, 0, initialColumnCount , initialRowCount);
			addHeaderRow();
		}
		
		private function addHeaderRow():void{
			function textFieldsDown(t:TextField):void{ t.y += t.height }
			applyToAll( textFieldsDown );
			
			var sampleTextField:TextField = TextField(textFields[0][0]); //　一番左上のマスをサンプルとして一個取得。
			
			for (var i:int = 0; i < visibleRange.width; i++){
				var tfld:TextFieldForTable = new TextFieldForTable();
				tfld.copyProperties(sampleTextField);
				tfld.x = i * tfld.width;
				tfld.y = 0;
				tfld.selectable = false; 　//選択可能である必要はない
				tfld.background = true;
				tfld.backgroundColor = 0xDDDDDD;
				columns[i].headerTextField = tfld;
				addChild(tfld);
			}
		}
		
		private function focusEntered(e:FocusEvent):void {
			/*	テキストフィールドにフォーカスが当たったら、その時点でのテキストを記録しておく。
			*	フォーカスアウト時のイベントハンドラ内で、その文字列を比較するために使用する。
			*	回りくどいが、この言語のテキストフィールドクラスには、テキストが確定した時に送出されるイベントがない。
			* 	そのため、フォーカスインとフォーカスアウトを入力確定として扱う。
			*/
			editingString = e.target.text;
			focusingTextField = TextFieldForTable(e.target);
		}
		
		private function focusOuted(e:FocusEvent):void {
			setDataSourceValue(TextFieldForTable(e.target));
			focusingTextField = null;
		}
		
		private function setDataSourceValue(currentCell:TextFieldForTable):void {
			//テキストに変更がなければここから下の処理は必要ない。
			if (currentCell.text === editingString) return
			
			var pointOnDataSource:Point = currentCell.PointOfShowingValue;
			var propertyName:String = columnPropertyNames[pointOnDataSource.x];
			
			var valueSettingEvent:TextTableEvent = new TextTableEvent(TextTableEvent.SOURCE_VALUE_SETTING, true);
			currentCell.dispatchEvent(valueSettingEvent);
			
			//	valueSettingEventが処理されて返ってきた際、呼び出し側によって変数がセットされていた場合はそっちを優先する。
			//	また、セッティングをこのブロック内で行った場合、以後の代入処理は不要なのでリターンする。
			if (valueSettingEvent.UserSetted){
				dataSource[pointOnDataSource.y][ propertyName ] = valueSettingEvent.SettingValue;
				return
			}
			
			// 実装方法が泥臭い。が、必要な機能をカバー可能なのでこれでいく。
			// 先にデータソース側のプロパティの型をチェック。
			// 以下のような型ならテキストフィールドの内容を型変換して入力する。
			if (dataSource[pointOnDataSource.y][propertyName] is int){
				dataSource[pointOnDataSource.y][ propertyName ] = int(currentCell.text);
			}
			else if (dataSource[pointOnDataSource.y][propertyName] is Boolean){
				dataSource[pointOnDataSource.y][ propertyName ] = Boolean(currentCell.text);
			}
			else if (dataSource[pointOnDataSource.y][propertyName] is String){
				dataSource[pointOnDataSource.y][ propertyName ] = currentCell.text;
			}
		}
		
		private function writeVisibleRange():void{
			var txFldRowCount:int = 0;
			for (var i:int = visibleRange.y; i < visibleRange.height + visibleRange.y; i++){
				for (var j:int = 0; j < columnPropertyNames.length; j++){
					var currentTextField:TextFieldForTable = textFields[ txFldRowCount ][j];
					currentTextField.text = dataSource[i][columnPropertyNames[j]];
					currentTextField.PointOfShowingValue.x = j;
					currentTextField.PointOfShowingValue.y = i;
					
					//イベントは内部のテキストフィールドから送付する（ターゲットが読み取り専用なのでここでセットできない）
					var textWritingEvent:TextTableEvent = new TextTableEvent(TextTableEvent.CELL_TEXT_WRITING,true);
					textWritingEvent.originalValue = dataSource[i][columnPropertyNames[j]];
					currentTextField.dispatchEvent(textWritingEvent);
				}
				txFldRowCount++;
			}
		}
				
		public function scrollDown(moveDistance:uint):void{
			if (visibleRange.y + visibleRange.height + moveDistance >= dataSource.length -1)
			{
				visibleRange.y = dataSource.length - visibleRange.height;
				writeVisibleRange();
				return;
			}
			visibleRange.y += moveDistance;
			writeVisibleRange();
		}
		
		public function scrollUp(moveDistance:uint):void{
			if (visibleRange.y - moveDistance < 0) {
				visibleRange.y = 0;
				writeVisibleRange();
				return;
			}
			visibleRange.y -= moveDistance;
			writeVisibleRange();
		}
		
		/**
		 * 現在操作中のテキストフィールドのテキストを、対応するデータソースに書き込みます。
		 */
		public function writeToDataSource():void{
			if (!focusingTextField) return;
			setDataSourceValue(focusingTextField);
		}
		
		/** 
		 * 関数オブジェクトを表内の全テキストフィールドに対して実行します。
		 * @param	callBackFunc	関数オブジェクトの仕様は　callBack(t:TextField)　です
		 */
		public function applyToAll(callBackFunc:Function):void{
			for (var i:int = 0; i < textFields.length; i++){
				for (var j:int = 0; j < textFields[i].length; j++){
					callBackFunc( textFields[i][j] );
				}
			}
		}
	}
}