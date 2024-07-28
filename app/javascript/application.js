// Entry point for the build script in your package.json
import { Application } from "@hotwired/stimulus";
const application = Application.start();
window.Stimulus = application;

import moment from "moment";
import Raphael from "raphael";

import Rails from "@rails/ujs";
import Notify from 'simple-notify';

window.moment = moment;
window.Raphael = Raphael;
window.Rails = Rails;
Rails.start();

import "./ckeditor";
import "./controllers";
import "./add_jquery";
import "./channels";

import { ApplicationController } from "./controllers/application_controller";
import { StudentsController } from "./controllers/students_controller";
import { ChartController } from "./controllers/chart_controller";
import { ExamController } from "./controllers/exam_controller";
import { BatchController } from "./controllers/batch_controller";
import { SubjectController } from "./controllers/subject_controller";
import { TeacherController } from "./controllers/teacher_controller";
import { TopicController } from "./controllers/topic_controller";
import { PaperController } from "./controllers/paper_controller";
import { QuestionController } from "./controllers/question_controller";
import { SideBarController } from "./controllers/side_bar_controller";
import { pushNotify } from './controllers/toastr_controller';


window.ApplicationController = ApplicationController;
window.StudentsController = StudentsController;
window.ChartController = ChartController;
window.ExamController = ExamController;
window.BatchController = BatchController;
window.SubjectController = SubjectController;
window.TeacherController = TeacherController;
window.TopicController = TopicController;
window.PaperController = PaperController;
window.QuestionController = QuestionController;
window.SideBarController = SideBarController;
window.Notify = Notify;
window.pushNotify = pushNotify;
