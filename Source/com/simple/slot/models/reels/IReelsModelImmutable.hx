package com.simple.slot.models.reels;

import openfl.events.IEventDispatcher;

interface IReelsModelImmutable extends IEventDispatcher
{
    var reelListImmutable(get, never):Array<ISingleReelModelImmutable>;
}
