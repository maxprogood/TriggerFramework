# Triggerframework
This project will make your work with triggers easier.
To use the project, you should create your own organization.</br>
[Please see guide for scratch org creation at path.](https://github.com/maxprogood/TriggerFramework/blob/master/FrameWork/Create%20Scrch%20Org.md)</br>
## Brief description of the project.
![Trigger Framework](C:\Users\maxpr\Desktop\UML-Triggerframework.png)


Trigger contains one line of calling the framework class as well as all  trigger events.
~~~
trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
        TriggerFramework.run();
}
~~~
After that, the class trigger framework is called.</br>
It takes information from custom metadata and populates the map with information about the handler.
~~~
private static final Map<String, List<TriggerHandlerConfig__mdt>>CONFIG_BY_TYPE = new Map<String, List<TriggerHandlerConfig__mdt>>();

    static {
        for (TriggerHandlerConfig__mdt record : TriggerHandlerConfig__mdt.getAll().values()) {
            if (!CONFIG_BY_TYPE.containsKey(record.ObjectName__c)) {
                CONFIG_BY_TYPE.put(record.ObjectName__c, new List<TriggerHandlerConfig__mdt>());
            } if (record.Active__c) {
                CONFIG_BY_TYPE.get(record.ObjectName__c).add(record);
            }
        }
    }
~~~
Then the run() method is called which, depending on the data received from the config, calls the desired handler.
~~~
    public static void run() {
        for (TriggerHandlerConfig__mdt config : CONFIG_BY_TYPE.get(getSObjName())) {
            TriggerHandler handler = (TriggerHandler) Type.forName(config.Handler__c).newInstance();
            switch on Trigger.operationType {
                when BEFORE_INSERT {
                    handler.beforeInsert(Trigger.new);
                }
                when BEFORE_UPDATE {
                    handler.beforeUpdate(Trigger.new, Trigger.oldMap);
                }
                when BEFORE_DELETE {
                    handler.beforeDelete(Trigger.old);
                }
                when AFTER_INSERT {
                    handler.afterInsert(Trigger.new);
                }
                when AFTER_UPDATE {
                    handler.afterUpdate(Trigger.new, Trigger.oldMap);
                }
                when AFTER_DELETE {
                    handler.afterDelete(Trigger.old);
                }
                when AFTER_UNDELETE {
                    handler.afterUnDelete(Trigger.new);
                }
            }
        }
    }
~~~
I also want to pay attention to the method getSObjName() which returns a string that contains objectName for run() method.
~~~
private static String getSObjName() {
        return Trigger.isDelete ?
                String.valueOf(Trigger.old.getSObjectType()) :
                String.valueOf(Trigger.new.getSObjectType());
    }
~~~
Then the trigger framework calls the necessary methods from the handler and completes its work.<br/>
[You can see examples of account handlers here...](https://github.com/maxprogood/TriggerFramework/blob/master/FrameWork/force-app/main/default/classes/AccountTriggerHandler.cls)
