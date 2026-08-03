REPORT ztask_log_seed.

DATA: lt_tasks TYPE TABLE OF ztask_log,
      ls_task  TYPE ztask_log,
      lv_ts    TYPE timestampl.

DATA(lv_now) = cl_abap_context_info=>get_system_date( ).

TYPES: BEGIN OF ty_template,
         title       TYPE char255,
         priority    TYPE int4,
         status      TYPE char20,
         assigned_to TYPE char12,
         due_offset  TYPE int4,
       END OF ty_template.

DATA lt_templates TYPE TABLE OF ty_template.
lt_templates = VALUE #(
  ( title = 'Fix login page crash'          priority = 1 status = 'OPEN'        assigned_to = 'MUELLER'   due_offset = 2  )
  ( title = 'Update user permissions'       priority = 2 status = 'IN_PROGRESS' assigned_to = 'SCHMIDT'   due_offset = 5  )
  ( title = 'Deploy hotfix to production'   priority = 1 status = 'DONE'        assigned_to = 'DEVELOPER' due_offset = 1  )
  ( title = 'Write unit tests for RFC'      priority = 2 status = 'OPEN'        assigned_to = 'FISCHER'   due_offset = 7  )
  ( title = 'Performance tuning on query'   priority = 1 status = 'IN_PROGRESS' assigned_to = 'WEBER'     due_offset = 3  )
  ( title = 'Code review for transport'     priority = 3 status = 'DONE'        assigned_to = 'DEVELOPER' due_offset = 4  )
  ( title = 'Document API endpoints'        priority = 3 status = 'OPEN'        assigned_to = 'MUELLER'   due_offset = 10 )
  ( title = 'Migrate legacy batch job'      priority = 2 status = 'IN_PROGRESS' assigned_to = 'SCHMIDT'   due_offset = 6  )
  ( title = 'Fix authorization check'       priority = 1 status = 'OPEN'        assigned_to = 'FISCHER'   due_offset = 2  )
  ( title = 'Cleanup obsolete programs'     priority = 3 status = 'DONE'        assigned_to = 'WEBER'     due_offset = 8  )
).

DATA(lv_template_count) = lines( lt_templates ).

GET TIME STAMP FIELD lv_ts.

DO 100 TIMES.
  DATA(lv_idx) = ( sy-index - 1 ) MOD lv_template_count + 1.
  DATA(ls_tmpl) = lt_templates[ lv_idx ].

  CLEAR ls_task.
  TRY.
      ls_task-task_uuid            = cl_system_uuid=>create_uuid_x16_static( ).
    CATCH cx_uuid_error.
      CONTINUE.
  ENDTRY.

  ls_task-title                  = |{ sy-index WIDTH = 3 ALIGN = RIGHT PAD = '0' }. { ls_tmpl-title }|.
  ls_task-priority               = ls_tmpl-priority.
  ls_task-status                 = ls_tmpl-status.
  ls_task-assigned_to            = ls_tmpl-assigned_to.
  ls_task-due_date               = lv_now + ls_tmpl-due_offset + sy-index.
  ls_task-created_by             = 'DEVELOPER'.
  ls_task-created_at             = lv_ts.
  ls_task-last_changed_by        = 'DEVELOPER'.
  ls_task-last_changed_at        = lv_ts.
  ls_task-local_last_changed_at  = lv_ts.

  APPEND ls_task TO lt_tasks.
ENDDO.

INSERT ztask_log FROM TABLE lt_tasks.

IF sy-subrc = 0.
  WRITE: / |{ lines( lt_tasks ) } records inserted successfully.|.
ELSE.
  WRITE: / |Insert failed. SY-SUBRC = { sy-subrc }|.
ENDIF.
