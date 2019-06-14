package com.simple.slot.models.app;
import openfl.events.IEventDispatcher;
interface IAppModelImmutable extends IEventDispatcher{
    var balance(get, never):Int;
    var spinCost(get, never):Int;
    var isTampering(get, never):Bool;
    var isLocked(get, never):Bool;
    var hasEnoughMoney(get, never):Bool;
}
