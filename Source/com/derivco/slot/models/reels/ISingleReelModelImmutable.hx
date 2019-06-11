package com.derivco.slot.models.reels;
import openfl.events.IEventDispatcher;
interface ISingleReelModelImmutable extends IEventDispatcher {
    public var symbolList(get, never):Array<Dynamic>;
}
