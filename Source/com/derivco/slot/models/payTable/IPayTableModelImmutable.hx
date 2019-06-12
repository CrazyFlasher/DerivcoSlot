package com.derivco.slot.models.payTable;
import openfl.events.IEventDispatcher;
interface IPayTableModelImmutable extends IEventDispatcher{
    var payTableListImmutable(get, never):Array<IPayTableItemModelImmutable>;
    var payout(get, never):Int;
}
