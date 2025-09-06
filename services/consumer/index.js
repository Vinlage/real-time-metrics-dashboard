import { SQSClient, ReceiveMessageCommand, DeleteMessageCommand } from '@aws-sdk/client-sqs';
import { WebSocketServer } from 'ws';
import 'dotenv/config';

const sqs = new SQSClient({ 
    endpoint: process.env.LOCALSTACK_ENDPOINT,
    region: process.env.AWS_REGION,
    credentials: {
        accessKeyId: process.env.AWS_ACCESS_KEY_ID,
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    },
});
const wsServer = new WebSocketServer({ port: 8080 });

async function pollQueue() {
  const data = await sqs.send(new ReceiveMessageCommand({
    QueueUrl: process.env.SQS_QUEUE_URL,
    MaxNumberOfMessages: 10,
    WaitTimeSeconds: 1,
  }));

  if (data.Messages) {
    data.Messages.forEach(msg => {
      const message = JSON.parse(msg.Body).Message;
      wsServer.clients.forEach(client => client.send(message));
      sqs.send(new DeleteMessageCommand({ QueueUrl: process.env.SQS_QUEUE_URL, ReceiptHandle: msg.ReceiptHandle }));
    });
  }
}

setInterval(pollQueue, 1000);

wsServer.on('connection', ws => {
  console.log('Client connected');
});