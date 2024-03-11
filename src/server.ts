import { App } from '@/app';
import { ValidateEnv } from '@utils/validateEnv';
import { DayPlanRoute } from './routes/dayPlans.route';

ValidateEnv();

const app = new App([new DayPlanRoute()]);

app.listen();
