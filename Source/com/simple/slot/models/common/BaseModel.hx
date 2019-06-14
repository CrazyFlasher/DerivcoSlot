package com.simple.slot.models.common;

import openfl.events.EventDispatcher;

class BaseModel extends EventDispatcher implements IBaseModel
{
    private var json:Dynamic;

    public function new()
    {
        super();
    }

    public function setJsonData(json:Dynamic):Void
    {
        this.json = json;
    }
}
