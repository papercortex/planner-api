import { IsString, IsNumber, IsNotEmpty, IsOptional, ValidateNested, IsArray, IsBoolean, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';

class GoalDto {
  @IsString()
  @IsNotEmpty()
  public title: string;

  @IsOptional()
  public metadata: any; // Consider using a more specific type or validation if possible
}

class TaskDto {
  @IsString()
  @IsNotEmpty()
  public title: string;

  @IsOptional()
  @IsBoolean()
  public checked?: boolean;

  @IsNumber()
  @Min(0)
  @Max(23)
  public fromHour: number;

  @IsNumber()
  @Min(0)
  @Max(59)
  public fromMin: number;

  @IsNumber()
  @Min(0)
  @Max(23)
  public toHour: number;

  @IsNumber()
  @Min(0)
  @Max(59)
  public toMin: number;

  @IsOptional()
  public metadata: any; // Consider using a more specific type or validation if possible
}

export class CreateDayPlanDto {
  @IsString()
  @IsNotEmpty()
  public fullMonthName: string;

  @IsNumber()
  @IsNotEmpty()
  public monthDay: number;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => GoalDto)
  public goals: GoalDto[];

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => TaskDto)
  public tasks: TaskDto[];
}
