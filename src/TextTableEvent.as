package {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class TextTableEvent extends Event {
		
		public static const CELL_TEXT_WRITING:String = "CellTextWriting";
		
		/**	イベントタイプにこの値を指定した場合、
		 * "テーブル内のテキストフィールドの文字列"　が　データソースの値に書き込みされる直前にイベントを受け取ることができます。
		 * 書き込まれる値を変更したい場合、このイベントの settingValue フィールドに値を代入してください。
		 */
		public static const SOURCE_VALUE_SETTING:String = "SourceValueSetting";
		
		/** テキストフィールドに文字列として書き込みされる前のデータソースの値です。 */
		public var originalValue:*;
		
		private var settingValue:*;
		public function set SettingValue(val:*):void{
			this.settingValue = val;
			userSetted = true;
		}
		public function get SettingValue():*{ return settingValue }
		
		/** SettingValue の値に対して、ユーザーが代入を行ったかどうかを示します。*/
		public function get UserSetted():Boolean { return userSetted };
		private var userSetted:Boolean = false;
		
		public function TextTableEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new TextTableEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("TextWriting", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}