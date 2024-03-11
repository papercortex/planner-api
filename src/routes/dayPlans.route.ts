import { Router } from 'express';
import { DayPlanController } from '@controllers/dayPlans.controller';
import { CreateDayPlanDto } from '@dtos/dayPlans.dto';
import { Routes } from '@interfaces/routes.interface';
import { ValidationMiddleware } from '@middlewares/validation.middleware';

export class DayPlanRoute implements Routes {
  public path = '/dayplans';
  public router = Router();
  public dayPlanController = new DayPlanController();

  constructor() {
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.get(`${this.path}`, this.dayPlanController.getDayPlans);
    this.router.get(`${this.path}/:id`, this.dayPlanController.getDayPlanById);
    this.router.post(`${this.path}`, ValidationMiddleware(CreateDayPlanDto), this.dayPlanController.createDayPlan);
    this.router.put(`${this.path}/:id`, ValidationMiddleware(CreateDayPlanDto, true), this.dayPlanController.updateDayPlan);
    this.router.delete(`${this.path}/:id`, this.dayPlanController.deleteDayPlan);
  }
}
