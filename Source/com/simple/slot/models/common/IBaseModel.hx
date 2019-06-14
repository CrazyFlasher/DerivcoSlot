package com.simple.slot.models.common;

import openfl.events.IEventDispatcher;

interface IBaseModel extends IEventDispatcher
{
    function setJsonData(json:Dynamic):Void;
}
