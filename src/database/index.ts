import { ConnectOptions, connect, set } from 'mongoose';
import { NODE_ENV, MONGODB_URI } from '@config';

export const dbConnection = async () => {
  const dbConfig: ConnectOptions = {};

  if (NODE_ENV !== 'production') {
    set('debug', true);
  }

  try {
    await connect(MONGODB_URI, dbConfig);
  } catch (error) {
    console.error(`Error connecting to the database: ${error}`);
  }
};
