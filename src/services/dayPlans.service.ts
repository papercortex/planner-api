import { Service } from 'typedi';
import { HttpException } from '@exceptions/HttpException';
import { DayPlanModel } from '@models/dayPlans.model';
import { DayPlan } from '@interfaces/dayPlans.interface';

@Service()
export class DayPlanService {
  public async findAllDayPlans(): Promise<DayPlan[]> {
    const dayPlans: DayPlan[] = await DayPlanModel.find();
    return dayPlans;
  }

  public async findDayPlanById(dayPlanId: string): Promise<DayPlan> {
    const dayPlan: DayPlan = await DayPlanModel.findOne({ _id: dayPlanId });
    if (!dayPlan) throw new HttpException(409, "DayPlan doesn't exist");

    return dayPlan;
  }

  public async createDayPlan(dayPlanData: DayPlan): Promise<DayPlan> {
    // Try to find an existing dayPlan with the same month and day
    const existingDayPlan = await DayPlanModel.findOne({
      fullMonthName: dayPlanData.fullMonthName,
      monthDay: dayPlanData.monthDay,
    });

    // If found, delete the existing dayPlan
    if (existingDayPlan) {
      await DayPlanModel.deleteOne({ _id: existingDayPlan._id });
    }

    // Then create the new dayPlan
    const createDayPlanData: DayPlan = await DayPlanModel.create(dayPlanData);

    return createDayPlanData;
  }

  public async updateDayPlan(dayPlanId: string, dayPlanData: DayPlan): Promise<DayPlan> {
    const updateDayPlanById: DayPlan = await DayPlanModel.findByIdAndUpdate(dayPlanId, dayPlanData, { new: true });
    if (!updateDayPlanById) throw new HttpException(409, "DayPlan doesn't exist");

    return updateDayPlanById;
  }

  public async deleteDayPlan(dayPlanId: string): Promise<DayPlan> {
    const deleteDayPlanById: DayPlan = await DayPlanModel.findByIdAndDelete(dayPlanId);
    if (!deleteDayPlanById) throw new HttpException(409, "DayPlan doesn't exist");

    return deleteDayPlanById;
  }
}
