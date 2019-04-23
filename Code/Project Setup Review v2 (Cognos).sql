select 
    "qProject8"."Project_ID" AS "Project_ID", 
    "qProject8"."Project_Name" AS "Project_Name", 
    "qProject8"."Organization_ID" AS "Organization_ID", 
    "qProject8"."Project_Manager_Name" AS "Project_Manager_Name", 
    "qProject8"."Billable_Project__Y_N_" AS "Billable_Project__Y_N_", 
    "qProject8"."Project_Modification_ID" AS "Project_Modification_ID", 
    "qProject8"."Effective_Date" AS "Effective_Date", 
    "qProject8"."Project_Start_Date" AS "Project_Start_Date", 
    "qProject8"."Project_End_Date" AS "Project_End_Date", 
    sum("qProject8"."Total_Value") AS "Total_Value", 
    "qProject8"."Project_Type_Desc" AS "Project_Type_Desc", 
    sum("qProject8"."Total_Funded") AS "Total_Funded", 
    "qTotal_Budget9"."Total_Budget" AS "Total_Budget"
    from (
select 
    "PROJ6"."PROJ_ID" AS "Project_ID", 
    "PROJ6"."PROJ_NAME" AS "Project_Name", 
    "PROJ6"."ORG_ID" AS "Organization_ID", 
    "PROJ6"."PROJ_MGR_NAME" AS "Project_Manager_Name", 
    "PROJ6"."BILL_PROJ_FL" AS "Billable_Project__Y_N_", 
    "PROJ_MOD"."PROJ_MOD_ID" AS "Project_Modification_ID", 
    cast("PROJ_MOD"."EFFECT_DT" as date) AS "Effective_Date", 
    cast("PROJ_MOD"."PROJ_START_DT" as date) AS "Project_Start_Date", 
    cast("PROJ_MOD"."PROJ_END_DT" as date) AS "Project_End_Date", 
    sum("PROJ_MOD"."PROJ_V_CST_AMT" + "PROJ_MOD"."PROJ_V_FEE_AMT") AS "Total_Value", 
    sum("PROJ_MOD"."PROJ_F_CST_AMT" + "PROJ_MOD"."PROJ_F_FEE_AMT") AS "Total_Funded", 
    "PROJ6"."PROJ_TYPE_DC" AS "Project_Type_Desc"
        from 
            "CP7_DATA"."DELTEK"."PROJ" "PROJ6" 
            LEFT OUTER JOIN 
            "CP7_DATA"."DELTEK"."PROJ_MOD" "PROJ_MOD" 
            on "PROJ6"."PROJ_ID" = "PROJ_MOD"."PROJ_ID"
        where  
            NOT "PROJ_MOD"."PROJ_MOD_ID" is null
        group by 
            "PROJ6"."PROJ_ID", 
            "PROJ6"."PROJ_NAME", 
            "PROJ6"."ORG_ID", 
            "PROJ6"."PROJ_MGR_NAME", 
            "PROJ6"."BILL_PROJ_FL", 
            "PROJ_MOD"."PROJ_MOD_ID", 
            cast("PROJ_MOD"."EFFECT_DT" as date), 
            cast("PROJ_MOD"."PROJ_START_DT" as date), 
            cast("PROJ_MOD"."PROJ_END_DT" as date), 
            "PROJ6"."PROJ_TYPE_DC") "qProject8" 
            LEFT OUTER JOIN (
select 
    "PROJ_TOT_BUD_DIR"."PROJ_ID" AS "Project_ID", 
    "PROJ_TOT_BUD_DIR"."BUD_AMT" AS "Total_Budget"
        from 
        "CP7_DATA"."DELTEK"."PROJ_TOT_BUD_DIR" "PROJ_TOT_BUD_DIR", 
        "CP7_DATA"."DELTEK"."PROJ" "PROJ7"
        where 
            "PROJ7"."ACCT_GRP_CD" in ('BP', 'BDV', 'BDO') and 
            "PROJ_TOT_BUD_DIR"."PROJ_ID" = "PROJ7"."PROJ_ID") "qTotal_Budget9" 
            on "qProject8"."Project_ID" = "qTotal_Budget9"."Project_ID"
    group by 
        "qProject8"."Project_ID", 
        "qProject8"."Project_Name", 
        "qProject8"."Organization_ID", 
        "qProject8"."Project_Manager_Name", 
        "qProject8"."Billable_Project__Y_N_", 
        "qProject8"."Project_Modification_ID", 
        "qProject8"."Effective_Date", 
        "qProject8"."Project_Start_Date", 
        "qProject8"."Project_End_Date", 
        "qProject8"."Project_Type_Desc", 
        "qTotal_Budget9"."Total_Budget"