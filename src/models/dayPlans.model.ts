import { DayPlan } from '@/interfaces/dayPlans.interface';
import { model, Schema, Document } from 'mongoose';

const GoalSchema: Schema = new Schema({
  title: { type: String, required: true },
  metadata: { type: Schema.Types.Mixed },
});

const TaskSchema: Schema = new Schema({
  title: { type: String, required: true },
  checked: { type: Boolean },
  fromHour: { type: Number, required: true },
  fromMin: { type: Number, required: true },
  toHour: { type: Number, required: true },
  toMin: { type: Number, required: true },
  metadata: { type: Schema.Types.Mixed },
});

const DayPlanSchema: Schema = new Schema({
  fullMonthName: { type: String, required: true },
  monthDay: { type: Number, required: true },
  goals: [GoalSchema],
  tasks: [TaskSchema],
});

export const DayPlanModel = model<DayPlan & Document>('DayPlan', DayPlanSchema);
