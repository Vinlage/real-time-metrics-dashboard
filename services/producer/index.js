import 'dotenv/config';
import { SNSClient, PublishCommand } from '@aws-sdk/client-sns';
import { faker } from '@faker-js/faker';

const sns = new SNSClient({
  endpoint: process.env.LOCALSTACK_ENDPOINT,
  region: process.env.AWS_REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
});

async function publishFakeMetric() {
  const metric = {
    timestamp: new Date().toISOString(),
    cpu: faker.number.int({ min: 0, max: 100 }),
    memory: faker.number.int({ min: 0, max: 100 }),
  };

  await sns.send(new PublishCommand({
    TopicArn: process.env.SNS_TOPIC_ARN,
    Message: JSON.stringify(metric),
  }));

  console.log('Metric published:', metric);
}

setInterval(publishFakeMetric, 3000);