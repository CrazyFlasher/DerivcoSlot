package com.simple.slot.models.payTable;

import openfl.events.IEventDispatcher;

interface IPayTableModelImmutable extends IEventDispatcher
{
    var itemListWithPayout(get, never):Array<IPayTableItemModelImmutable>;
    var payTableListImmutable(get, never):Array<IPayTableItemModelImmutable>;
    var payout(get, never):Int;
}
