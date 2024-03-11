import { ConnectOptions, connect, set } from 'mongoose';
import { NODE_ENV, DB_HOST, DB_PORT, DB_DATABASE } from '@config';

export const dbConnection = async () => {
  const dbConfig: ConnectOptions = {};

  const url = `mongodb://${DB_HOST}:${DB_PORT}/${DB_DATABASE}`;

  if (NODE_ENV !== 'production') {
    set('debug', true);
  }

  await connect(url, dbConfig);
};
