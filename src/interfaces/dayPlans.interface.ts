interface Goal {
  title: string;
  metadata?: any;
}

interface Task {
  title: string;
  checked?: boolean;
  fromHour: number;
  fromMin: number;
  toHour: number;
  toMin: number;
  metadata?: any;
}

export interface DayPlan {
  _id?: string;
  fullMonthName: string;
  monthDay: number;
  goals: Goal[];
  tasks: Task[];
}
