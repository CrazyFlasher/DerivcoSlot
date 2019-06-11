package com.derivco.slot.models.app;
import openfl.events.IEventDispatcher;
interface IAppModelImmutable extends IEventDispatcher{
    var balance(get, never):Int;
    var spinCost(get, never):Int;
    var isTampering(get, never):Bool;
}
