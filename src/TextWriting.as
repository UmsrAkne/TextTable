package {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class TextWriting extends Event {
		
		public static const TEXT_WRITING:String = "TextWriting";
		
		/**	イベントタイプにこの値を指定した場合、
		 * "テーブル内のテキストフィールドの文字列"　が　データソースの値に書き込みされる直前にイベントを受け取ることができます。
		 * 書き込まれる値を変更したい場合、このイベントの settingValue フィールドに値を代入してください。
		 */
		public static const VALUE_SETTING:String = "ValueSetting"
		
		public var originalValue:*;
		
		private var settingValue:*;
		public function set SettingValue(val:*):void{
			this.settingValue = val;
			userSetted = true;
		}
		public function get SettingValue():*{ return settingValue }
		
		
		/** SettingValue の値に対して、ユーザーが代入を行ったかどうかを示します。
		 */
		public function get UserSetted():Boolean { return userSetted };
		private var userSetted:Boolean = false;
		
		public function TextWriting(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new TextWriting(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("TextWriting", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}