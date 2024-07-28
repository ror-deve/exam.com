module DashboardHelper
  def authorized_to_access_audit_teacher?(audit, current_teacher)
    case audit.auditable_type
    when "AccountTeacher", "Teacher"
      true
    else
      false
    end
  end

  def filter_and_fetch_audits_teacher(current_teacher, date_filter)
    start_date, end_date = case date_filter
                          when 'today'
                            [Time.zone.now.beginning_of_day, Time.zone.now.end_of_day]
                          when 'this_week'
                            [Time.zone.now.beginning_of_week, Time.zone.now.end_of_week]
                          when 'this_month'
                            [Time.zone.now.beginning_of_month, Time.zone.now.end_of_month]
                          when 'this_year'
                            [Time.zone.now.beginning_of_year, Time.zone.now.end_of_year]
                          else
                            [nil, nil]
                          end

    teacher_audits = fetch_audits("Teacher", start_date, end_date)
    account_teacher_audits = fetch_audits("AccountTeacher", start_date, end_date)

    (teacher_audits + account_teacher_audits).sort_by(&:created_at).reverse
  end

  def authorized_to_access_audit_student?(audit, current_student)
    audit.auditable_type == "Student"
  end

  def filter_and_fetch_audits_student(current_student, date_filter)
    start_date, end_date = case date_filter
                          when 'today'
                            [Time.zone.now.beginning_of_day, Time.zone.now.end_of_day]
                          when 'this_week'
                            [Time.zone.now.beginning_of_week, Time.zone.now.end_of_week]
                          when 'this_month'
                            [Time.zone.now.beginning_of_month, Time.zone.now.end_of_month]
                          when 'this_year'
                            [Time.zone.now.beginning_of_year, Time.zone.now.end_of_year]
                          else
                            [nil, nil]
                          end

    student_audits = fetch_audits("Student", start_date, end_date)

    student_audits.sort_by(&:created_at).reverse
  end

  private

  def fetch_audits(auditable_type, start_date, end_date)
    if start_date && end_date
      audits = Audited::Audit.where(auditable_type: auditable_type, created_at: start_date..end_date)
    else
      audits = Audited::Audit.where(auditable_type: auditable_type)
    end
    audits
  end
end
