const { Logger } = require('../libraries/Logger');

function parse(message) {
  const parsedSocketData = JSON.parse(message.utf8Data);
  Logger.json('WebSocket data received:', parsedSocketData);

  const result = {
    requester: parsedSocketData[0],
    messageId: parsedSocketData[1],
  };

  if (typeof parsedSocketData[2] === 'string') {
    result.messageType = MessageTypeEnum.TYPE_RESPONSE;
    result.body = parsedSocketData[2];
  } else {
    result.messageType = MessageTypeEnum.TYPE_REQUEST;
    result.command = parsedSocketData[2];
    result.body = parsedSocketData[3];
  }

  return result;
}

const MessageTypeEnum = {
  TYPE_RESPONSE: 'response',
  TYPE_REQUEST: 'request',
};

const RequestorEnum = {
  REQUESTOR_SERVER: 3,
  REQUESTOR_CLIENT: 2,
  REQUESTOR_ERROR: 2,
};

module.exports = {
  DataParser: {
    parse: parse,
  },
  MessageTypeEnum: MessageTypeEnum,
  RequestorEnum: RequestorEnum,
};
