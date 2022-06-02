public class TriggerFramework {
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

    private static String getSObjName() {
        return Trigger.isDelete ?
                String.valueOf(Trigger.old.getSObjectType()) :
                String.valueOf(Trigger.new.getSObjectType());
    }


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
}




