package com.derivco.slot.models.payTable;
import openfl.events.IEventDispatcher;
interface IPayTableModelImmutable extends IEventDispatcher{
    var payout(get, never):Int;
}
