package org.scada_lts.workdomain.datasource.amqp;

import com.serotonin.json.*;
import com.serotonin.mango.Common;
import com.serotonin.mango.rt.dataSource.DataSourceRT;
import com.serotonin.mango.rt.event.type.AuditEventType;
import com.serotonin.mango.util.ExportCodes;
import com.serotonin.mango.vo.dataSource.DataSourceVO;
import com.serotonin.mango.vo.dataSource.PointLocatorVO;
import com.serotonin.mango.vo.event.EventTypeVO;
import com.serotonin.util.SerializationHelper;
import com.serotonin.web.dwr.DwrResponseI18n;
import com.serotonin.web.i18n.LocalizableMessage;
import org.scada_lts.serorepl.utils.StringUtils;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.List;
import java.util.Map;

/**
 * AMQP Receiver DataSource Virtual Object
 * RabbitMQ AMQP version = 0.9.1 (default)
 *
 * @author Radek Jajko
 * @version 1.0
 * @since 2018-09-11
 */
@JsonRemoteEntity
public class AmqpReceiverDataSourceVO extends DataSourceVO<AmqpReceiverDataSourceVO> {

    public static final Type TYPE = Type.AMQP_RECEIVER;

    private int updatePeriodType = Common.TimePeriods.MINUTES;
    @JsonRemoteProperty
    private int updatePeriods = 5;
    @JsonRemoteProperty
    private int updateAttempts = 5;
    @JsonRemoteProperty
    private String serverIpAddress = new String("localhost");
    @JsonRemoteProperty
    private String serverPortNumber = new String("5672");
    @JsonRemoteProperty
    private String serverVirtualHost = new String("");
    @JsonRemoteProperty
    private String serverUsername = new String("");
    @JsonRemoteProperty
    private String serverPassword = new String("");

    @Override
    protected void addEventTypes(List<EventTypeVO> eventTypes) {
        eventTypes.add(createEventType(AmqpReceiverDataSourceRT.DATA_SOURCE_EXCEPTION_EVENT, new LocalizableMessage("event.ds.dataSource") ));
        eventTypes.add(createEventType(AmqpReceiverDataSourceRT.DATA_POINT_EXCEPTION_EVENT, new LocalizableMessage("event.ds.amqpReceiver") ));

    }

    @Override
    protected void addPropertiesImpl(List<LocalizableMessage> list) {
        AuditEventType.addPeriodMessage(list, "dsEdit.updatePeriod", updatePeriodType, updatePeriods);
        AuditEventType.addPropertyMessage(list, "dsEdit.amqpReceiver.serverIpAddress" , serverIpAddress);
        AuditEventType.addPropertyMessage(list, "dsEdit.amqpReceiver.serverPortNumber" , serverPortNumber);
        AuditEventType.addPropertyMessage(list, "dsEdit.amqpReceiver.serverVirtualHost" , serverVirtualHost);
        AuditEventType.addPropertyMessage(list, "dsEdit.amqpReceiver.serverUsername" , serverUsername);
        AuditEventType.addPropertyMessage(list, "dsEdit.amqpReceiver.serverPassword" , serverPassword);

    }

    @Override
    protected void addPropertyChangesImpl(List<LocalizableMessage> list, AmqpReceiverDataSourceVO from) {
        AuditEventType.maybeAddPeriodChangeMessage(list, "dsEdit.updatePeriod", from.updatePeriodType, from.updatePeriods ,updatePeriodType, updatePeriods);
        AuditEventType.maybeAddPropertyChangeMessage(list,"dsEdit.amqpReceiver.serverIpAddress",from.serverIpAddress,serverIpAddress);
        AuditEventType.maybeAddPropertyChangeMessage(list,"dsEdit.amqpReceiver.serverPortNumber",from.serverPortNumber,serverPortNumber);
        AuditEventType.maybeAddPropertyChangeMessage(list,"dsEdit.amqpReceiver.serverVirtualHost",from.serverVirtualHost,serverVirtualHost);
        AuditEventType.maybeAddPropertyChangeMessage(list,"dsEdit.amqpReceiver.serverUsername",from.serverUsername,serverUsername);
        AuditEventType.maybeAddPropertyChangeMessage(list,"dsEdit.amqpReceiver.serverPassword",from.serverPassword,serverPassword);
    }

    @Override
    public DataSourceRT createDataSourceRT() {
        return new AmqpReceiverDataSourceRT(this);
    }

    @Override
    public PointLocatorVO createPointLocator() {
        return new AmqpReceiverPointLocatorVO();
    }

    @Override
    public LocalizableMessage getConnectionDescription() {
        if (serverIpAddress.length() == 0 || serverPortNumber.length() == 0)
            return new LocalizableMessage("dsEdit.amqpReceiver");
        return null;
    }

    private static final ExportCodes EVENT_CODES = new ExportCodes();
    static {
        EVENT_CODES.addElement(AmqpReceiverDataSourceRT.DATA_SOURCE_EXCEPTION_EVENT, "DATA_SOURCE_EXCEPTION");
        EVENT_CODES.addElement(AmqpReceiverDataSourceRT.DATA_POINT_EXCEPTION_EVENT, "DATA_POINT_EXCEPTION");
    }

    @Override
    public ExportCodes getEventCodes() {
        return EVENT_CODES;
    }

    @Override
    public Type getType() {
        return TYPE;
    }


    @Override
    public void validate(DwrResponseI18n response) {
        super.validate(response);
        if (StringUtils.isEmpty(serverIpAddress)) {
            response.addContextualMessage("serverIpAddress","validate.required");
        }
        try {
            InetAddress.getByName(serverIpAddress);
        } catch (UnknownHostException e) {
            response.addContextualMessage("serverIpAddress","validate.invalidValue");
        }
        if (StringUtils.isEmpty(serverPortNumber) || Integer.parseInt(serverPortNumber) < 0) {
            response.addContextualMessage("serverPortNumber","validate.invalidValue");
        }
        if (updateAttempts < 0 || updateAttempts > 10) {
            response.addContextualMessage("updateAttempts", "validate.updateAttempts");
        }

    }

    private static final int version = 1;

    private void writeObject(ObjectOutputStream out) throws IOException {

        out.writeInt(version);
        out.writeInt(updatePeriodType);
        out.writeInt(updatePeriods);
        out.writeInt(updateAttempts);
        SerializationHelper.writeSafeUTF(out, serverIpAddress);
        SerializationHelper.writeSafeUTF(out, serverPortNumber);
        SerializationHelper.writeSafeUTF(out, serverVirtualHost);
        SerializationHelper.writeSafeUTF(out, serverUsername);
        SerializationHelper.writeSafeUTF(out, serverPassword);

    }

    private void readObject(ObjectInputStream in) throws IOException {
        int ver = in.readInt();
        if (ver == 1) {
            updatePeriodType    = in.readInt();
            updatePeriods       = in.readInt();
            updateAttempts      = in.readInt();
            serverIpAddress     = SerializationHelper.readSafeUTF(in);
            serverPortNumber    = SerializationHelper.readSafeUTF(in);
            serverVirtualHost   = SerializationHelper.readSafeUTF(in);
            serverUsername      = SerializationHelper.readSafeUTF(in);
            serverPassword      = SerializationHelper.readSafeUTF(in);

        }
    }

    @Override
    public void jsonSerialize(Map<String, Object> map){
        super.jsonSerialize(map);
        serializeUpdatePeriodType(map, updatePeriodType);
    }

    @Override
    public void jsonDeserialize(JsonReader reader, JsonObject json) throws JsonException {
        super.jsonDeserialize(reader,json);
        Integer value = deserializeUpdatePeriodType(json);
        if (value != null)
            updatePeriodType = value;
    }

    public int getUpdatePeriodType() {
        return updatePeriodType;
    }

    public void setUpdatePeriodType(int updatePeriodType) {
        this.updatePeriodType = updatePeriodType;
    }

    public int getUpdatePeriods() {
        return updatePeriods;
    }

    public void setUpdatePeriods(int updatePeriods) {
        this.updatePeriods = updatePeriods;
    }

    public int getUpdateAttempts() {
        return updateAttempts;
    }

    public void setUpdateAttempts(int updateAttempts) {
        this.updateAttempts = updateAttempts;
    }

    public String getServerIpAddress() {
        return serverIpAddress;
    }

    public void setServerIpAddress(String serverIpAddress) {
        this.serverIpAddress = serverIpAddress;
    }

    public String getServerPortNumber() {
        return serverPortNumber;
    }

    public void setServerPortNumber(String serverPortNumber) {
        this.serverPortNumber = serverPortNumber;
    }

    public String getServerVirtualHost() {
        return serverVirtualHost;
    }

    public void setServerVirtualHost(String serverVirtualHost) {
        this.serverVirtualHost = serverVirtualHost;
    }

    public String getServerUsername() {
        return serverUsername;
    }

    public void setServerUsername(String serverUsername) {
        this.serverUsername = serverUsername;
    }

    public String getServerPassword() {
        return serverPassword;
    }

    public void setServerPassword(String serverPassword) {
        this.serverPassword = serverPassword;
    }

}
