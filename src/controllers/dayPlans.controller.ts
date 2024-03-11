import { NextFunction, Request, Response } from 'express';
import { Container } from 'typedi';
import { DayPlanService } from '@services/dayPlans.service';
import { DayPlan } from '@interfaces/dayPlans.interface';

export class DayPlanController {
  public dayPlanService = Container.get(DayPlanService);

  public getDayPlans = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const findAllDayPlansData: DayPlan[] = await this.dayPlanService.findAllDayPlans();

      res.status(200).json({ data: findAllDayPlansData, message: 'findAll' });
    } catch (error) {
      next(error);
    }
  };

  public getDayPlanById = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const dayPlanId: string = req.params.id;
      const findOneDayPlanData: DayPlan = await this.dayPlanService.findDayPlanById(dayPlanId);

      res.status(200).json({ data: findOneDayPlanData, message: 'findOne' });
    } catch (error) {
      next(error);
    }
  };

  public createDayPlan = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const dayPlanData: DayPlan = req.body;
      const createDayPlanData: DayPlan = await this.dayPlanService.createDayPlan(dayPlanData);

      res.status(201).json({ data: createDayPlanData, message: 'created' });
    } catch (error) {
      next(error);
    }
  };

  public updateDayPlan = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const dayPlanId: string = req.params.id;
      const dayPlanData: DayPlan = req.body;
      const updateDayPlanData: DayPlan = await this.dayPlanService.updateDayPlan(dayPlanId, dayPlanData);

      res.status(200).json({ data: updateDayPlanData, message: 'updated' });
    } catch (error) {
      next(error);
    }
  };

  public deleteDayPlan = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const dayPlanId: string = req.params.id;
      await this.dayPlanService.deleteDayPlan(dayPlanId);

      res.status(200).json({ message: 'deleted' });
    } catch (error) {
      next(error);
    }
  };
}
