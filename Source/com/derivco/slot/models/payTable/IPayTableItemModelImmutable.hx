package com.derivco.slot.models.payTable;
import openfl.events.IEventDispatcher;
interface IPayTableItemModelImmutable extends IEventDispatcher{
    var lineId(get, never):String;
    var symbolIdList(get, never):Array<Dynamic>;
    var payout(get, never):Int;

    var lastPayout(get, never):Int;
    var lastWinLine(get, never):String;
}
