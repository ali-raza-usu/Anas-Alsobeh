package aspects.ows;


import joinpoints.communication.ReceiveEventJP;
import joinpoints.communication.SendEventJP;
import joinpoints.communication.RequestReplyConversationJP;
import joinpoints.communication.SendEventJP;

import org.apache.log4j.Logger;
import exp.ftp.*;
import utilities.Encoder;
import utilities.Message;
import MessageVersion.MessageVersion;
//import baseaspects.communication.OneWayReceiveAspect;
import baseaspects.communication.OneWaySendAspect;


public aspect VersionOnSend extends OneWaySendAspect{
	private Logger logger = Logger.getLogger(VersionOnSend.class);
	
	after(SendEventJP _sendEventJp): ConversationBegin(_sendEventJp)
	{
		     			
		MessageVersion msg =  (MessageVersion)Encoder.decode(_sendEventJp.getBytes());
     	String logString = "OneWaySend: Sender: "+getTargetClass() + " - Message "+ msg.getClass().getSimpleName() + " ID = " +_sendEventJp.getConversation().getId().toString();
     	if(msg !=null)
     	{
     		logger.debug(getTargetClass() +"Message is "+ msg.getVersion());
     		
     		if(getTargetClass().equals("FTPClient"))
     		{
    			msg.setSender_version("1.0");
    			msg.setReceiver_version("0.0");
     			logString+="\n"+" The expected version is: 1.0"+ " The actual version is:"+msg.getVersion();
     		}
     		if(getTargetClass().equals("FTPServer"))
     		{
    			msg.setSender_version("0.0");
    			msg.setReceiver_version("1.0");
     			logString+="\n"+" The expected version is: 0.0"+ " The actual version is:"+msg.getVersion() ;
     		}
     	}
		
     	logger.debug(logString);		
		System.out.println(logString);
	}
	
	public static String getTargetClass() {
		StackTraceElement[] elements = Thread.currentThread().getStackTrace();
		String[] classes = elements[elements.length - 1].getClassName().split("\\.");
		return classes[classes.length - 1];
	}

}
